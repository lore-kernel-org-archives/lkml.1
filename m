Return-Path: <linux-kernel-owner+w=401wt.eu-S1751982AbZHHVCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982AbZHHVCc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 17:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbZHHVCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 17:02:32 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:50462 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbZHHVCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 17:02:31 -0400
From: Martin Rogge <marogge@onlinehome.de>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.30.1-4 kernels freezes dual pentium-3 system
Date: Sat, 8 Aug 2009 23:03:52 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.30.4; KDE/4.2.1; i686; ; )
Cc: devzero@web.de
References: <859414371@web.de>
In-Reply-To: <859414371@web.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908082303.52471.marogge@onlinehome.de>
X-Provags-ID: V01U2FsdGVkX19BTJpc13M2FrsqU/EK+5aQ5jkNUbramhdcAwd
 e55SrLIgdI91vjLeaLwsICns3KHsWseNNH6S/msKaFMFmui8oQ
 42coKuOzeKezv93TnfARw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 08 August 2009 11:49:50 devzero@web.de wrote:

> > Btw, since then there have been two more
> > reports on lkml of dual P2 systems locking up with 2.6.30++.
>
> could you send pointers?

Since I am not subscribed to the LKML (I only read it via a NNTP relay) I have 
some difficulties providing IDs. Anyway, the subject of the reports I have in 
mind is "PROBLEM: crash / hang with linux-2.6.30.x on PII-350 SMP system".

> any existing bugzilla bugentry for these or for your`s ?

Earlier today I filed bug 13933 on kernel.bugzilla. Unfortunately I had some 
problems attaching all the files, so my earlier LKML post is still the best 
source of information.

> > Network, sysrq and numlock are all unresponsive.
>
> ok, that`s why we need to have the last informations from before the dying
> breath...

agreed.

>
> btw, i one of your dmesg i found these:
>
> Aug  1 19:42:57 frya kernel: [...]

Again, that's someone else's report. Regarding clocksource, while I was trying 
to hunt down this bug I once booted with "clocksource=acpi_pm" but it made no 
difference. Truth be told, at that time I was still troubleshooting the 
nvidia.ko driver.

Martin

