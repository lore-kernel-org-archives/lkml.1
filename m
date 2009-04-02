Return-Path: <linux-kernel-owner+w=401wt.eu-S1760073AbZDBMkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760073AbZDBMkd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 08:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755649AbZDBMkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 08:40:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:57573 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185AbZDBMkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 08:40:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Harry Ciao <qingtao.cao@windriver.com>
Subject: Re: [v0 PATCH 2/5] EDAC: Add CPC925 driver source file
Date: Thu, 2 Apr 2009 14:40:16 +0200
User-Agent: KMail/1.9.9
Cc: norsk5@yahoo.com, linux-kernel@vger.kernel.org,
       bluesmoke-devel@lists.sourceforge.net, linuxppc-dev@ozlabs.org
References: <1238652440-9224-1-git-send-email-qingtao.cao@windriver.com> <1238652440-9224-2-git-send-email-qingtao.cao@windriver.com> <1238652440-9224-3-git-send-email-qingtao.cao@windriver.com>
In-Reply-To: <1238652440-9224-3-git-send-email-qingtao.cao@windriver.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904021440.17366.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+rPAlLIgmL4JAqX2gC0JnAEjMcHHGHuBfncaO
 VQkpKSFAIli+z6jm0jK2ZfeTxvgcu7COI0qSC+wKdcl+vQO4xF
 1AYfGbj09izP/60DiVjsQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 April 2009, Harry Ciao wrote:
> Introduce IBM CPC925 EDAC driver source file, which makes use of error
> detections on the IBM CPC925 Bridge and Memory Controller.
> 
> Signed-off-by: Harry Ciao <qingtao.cao@windriver.com>

On a very brief review, the driver looks good to me, but please
post the full series to the linuxppc-dev@ozlabs.org mailing list
as well, because that is likely to have more people that will
comment on it.

The first three patches of your series should be merged into
a single one, because none of them has any signficance by itself.
You may also consider moving the contents of the header file
into the main driver, because it does not actually act as an
interface.

	Arnd <><
