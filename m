Return-Path: <linux-kernel-owner+w=401wt.eu-S1753369AbYKQQOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbYKQQOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 11:14:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918AbYKQQOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 11:14:25 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:16410 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbYKQQOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 11:14:24 -0500
Date: Mon, 17 Nov 2008 08:10:59 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       LKML <linux-kernel@vger.kernel.org>, linux-pcmcia@lists.infradead.org
Subject: Re: Strange behavior since commit 5fef0e5c
Message-Id: <20081117081059.e008ff46.randy.dunlap@oracle.com>
In-Reply-To: <491DECF9.6020707@lwfinger.net>
References: <491D92EB.2030200@lwfinger.net>
	<200811142053.05880.bzolnier@gmail.com>
	<491DECF9.6020707@lwfinger.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010204.492197DC.00BE:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2008 15:26:17 -0600 Larry Finger wrote:

> Bartlomiej Zolnierkiewicz wrote:
> > On Friday 14 November 2008, Larry Finger wrote:
> >> In testing kernel version 2.6.28-rc4 on my server that was running kernel
> >> 2.6.27, an external IDE disk system connected via a PCCard interface failed to
> >> start because module ide_disk would not load. The console output is as follows:
> >>
> >> finger@sonylap:~> sudo modprobe -v ide-disk
> >> WARNING: module 'ide_gd_mod' is unsupported
> >> FATAL: Module ide_disk not found.
> > 
> > Please verify that your system uses a recent module-init-tools version
> > and then repeat 'make modules' + 'make modules_install' (it could be that
> > something went wrong previously during installing modules) as it works
> > just fine for me with 2.6.28-rc3 and module-init-tools 3.4.
> 
> That was the problem. I had 3.3 pre11, which was installed by openSUSE 10.3.
> Updating to version 3.4 fixed the problem. Thanks.
> 
> Should the requirement in Documentation/Changes be modified, or is that info no
> longer used?

IMO it should be updated (or deleted if it's really useless).

---
~Randy
