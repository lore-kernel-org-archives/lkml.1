Return-Path: <linux-kernel-owner+w=401wt.eu-S1755239AbXLGMES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbXLGMES (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 07:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbXLGMEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 07:04:06 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:62519 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbXLGMEF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 07:04:05 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [RFC][POWERPC] Provide a way to protect 4k subpages when using 64k pages
Date: Fri, 7 Dec 2007 13:03:41 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
References: <18264.58263.818005.757831@cargo.ozlabs.ibm.com>
In-Reply-To: <18264.58263.818005.757831@cargo.ozlabs.ibm.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712071303.42413.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19byRNl0qQQtlcmWO5xKO9o/IpwbIM6PZ14/7O
 MhGSzZi8/ywDCbjaCdXoG1wm3FgCHgeYdW11tP006kv1eXDOTs
 uInE2bUAlWzOrvDTx0uxA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 December 2007, Paul Mackerras wrote:
> I have re-purposed the ioperm system call for this.  The old ioperm
> system call never did anything (except return an ENOSYS error) and in
> fact never could have actually been useful for anything on the PowerPC
> architecture, so nothing ever used it.

Couldn't there be a program that relies on ioperm to return -ENOSYS on
powerpc in order to fall back on some other method of I/O access?

The risk of actually breaking something is certainly low, but I think
you can never be sure here, so why not use a new syscall number?

	Arnd <><
