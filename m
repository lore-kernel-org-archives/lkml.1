Return-Path: <linux-kernel-owner+w=401wt.eu-S1754023AbYKYQD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbYKYQD4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 11:03:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbYKYQDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 11:03:48 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:59305 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbYKYQDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 11:03:47 -0500
X-Greylist: delayed 307 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Nov 2008 11:03:47 EST
From: Arnd Bergmann <arnd@arndb.de>
To: Carl Love <cel@us.ibm.com>
Subject: Re: [Patch 2/3] OProfile SPU event profiling support for IBM Cell processor
Date: Tue, 25 Nov 2008 16:58:26 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       oprofile-list@lists.sourceforge.net, cel <cel@linux.vnet.ibm.com>,
       cbe-oss-dev <cbe-oss-dev@ozlabs.org>
References: <1227569201.6509.214.camel@carll-linux-desktop>
In-Reply-To: <1227569201.6509.214.camel@carll-linux-desktop>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811251658.27387.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/0DhQQzgq+6gktTHDPBm+KzGThVx4rbSGE2n4
 uq/7fsYU/EarYgHKUwEUfdBPQw48Wq1Bi82nfirhrRXCqUDSeq
 p/tpOQYXsj6vYfBYi2w+g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 November 2008, Carl Love wrote:
> 
> This patch basically rearranges the code a bit to make it easier to
> just add the needed SPU event based profiling routines.   The second 
> kernel patch contains the new spu event based profiling code.

The cleanup looks fine, but should get a unique patch name, e.g. 
'[PATCH 2/3] powerpc/cell/oprofile: clean up event handling' to
make the shortlog more meaningful. No need to mention in the changelog
what the other patch does.

Please mention that this patch is not supposed to change any behaviour.

> Signed-off-by: Carl Love <carll@us.ibm.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
