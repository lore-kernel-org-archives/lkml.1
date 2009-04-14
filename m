Return-Path: <linux-kernel-owner+w=401wt.eu-S1756100AbZDNOgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100AbZDNOgn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 10:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbZDNOge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 10:36:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:64399 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbZDNOgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 10:36:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: michal.simek@petalogix.com
Subject: Re: struct exception_table_entry
Date: Tue, 14 Apr 2009 16:36:11 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
References: <49DE0EC4.4010409@petalogix.com>
In-Reply-To: <49DE0EC4.4010409@petalogix.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904141636.11676.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+7c3Nab+5/vGFEHjvqI2nrhdw+RzZtB9XlWQI
 6kw37YkRxivXSS1FMLbkMyew1cMUkoOPEPJs5dU5ZC4bQU1/dG
 GEKb64XgSJSegzUnaRPqw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 April 2009, Michal Simek wrote:

> I am doing some cleanup things in MB MMU kernel and I looked at
> exception_table_entry structure.
> Only alpha use different types among others. Some arch use only
> different names and types int/long.
> I think that this structure could be moved to any generic location ->
> asm-generic/uaccess.h folder.
> 
> I think that this structure types should be acceptable for every archs?
> 
> #ifndef exception_table_entry
> struct exception_table_entry {
>     unsigned long insn;
>     unsigned long fixup;
> };
> #endif
> 
> What do you think?

Yes, sounds good to me. Have you tried using my generic version of
uaccess.h on microblaze? It already contains a definition like this,
though most of the header doesn't apply for MMU-based architectures.

I suppose it can be improved a bit, but should do the basic job.

	Arnd <><
