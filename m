Return-Path: <linux-kernel-owner+w=401wt.eu-S1757718AbZDBMeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757718AbZDBMeY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 08:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752824AbZDBMeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 08:34:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:57527 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbZDBMeP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 08:34:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Harry Ciao <qingtao.cao@windriver.com>
Subject: Re: [v0 PATCH 3/5] EDAC: Add CPC925 driver Kconfig & Makefile
Date: Thu, 2 Apr 2009 14:34:03 +0200
User-Agent: KMail/1.9.9
Cc: norsk5@yahoo.com, linux-kernel@vger.kernel.org,
       bluesmoke-devel@lists.sourceforge.net
References: <1238652440-9224-1-git-send-email-qingtao.cao@windriver.com> <1238652440-9224-3-git-send-email-qingtao.cao@windriver.com> <1238652440-9224-4-git-send-email-qingtao.cao@windriver.com>
In-Reply-To: <1238652440-9224-4-git-send-email-qingtao.cao@windriver.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904021434.04558.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1912W6RhNeLlMy5MwkIqQm+6WDaeSbMB0L6K6R
 l1GPEopf2O3LriaUPqu5PT4gZ5zuBYxfW1vZVYgVnh9BZjrpjv
 BK/lX0Dv2MODiZgLahKHQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 April 2009, Harry Ciao wrote:
> +config EDAC_CPC925
> +       tristate "IBM CPC925 Memory Controller (PPC970FX)"
> +       depends on EDAC_MM_EDAC
> +       help
> +         Support for error detection and correction on the
> +         IBM CPC925 Bridge and Memory Controller, which is
> +         a companion chip to the PowerPC 970 family of
> +         processors.

This needs to depend on PPC64 as well, so it won't show up
on other architectures.

	Arnd <><
