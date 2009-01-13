Return-Path: <linux-kernel-owner+w=401wt.eu-S1756626AbZAMLrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626AbZAMLrZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 06:47:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752480AbZAMLrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 06:47:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47102 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038AbZAMLrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 06:47:13 -0500
Date: Tue, 13 Jan 2009 12:46:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       lkml <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org
Subject: Re: Regression 2.6.28-git: suspend/resume failure. git bisected to
	usb suspend/resume patch
Message-ID: <20090113114613.GB13940@elte.hu>
References: <200901111348.46216.borntraeger@de.ibm.com> <200901120103.53390.rjw@sisk.pl> <200901121341.51674.rjw@sisk.pl> <200901130907.13820.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901130907.13820.borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> Am Montag 12 Januar 2009 schrieb Rafael J. Wysocki:
> > > Please try if suspend-resume works for you if you make commit
> > > fa58d305d9925b01830e535896a7227a868a9e15
> > > (PCI PM: Add suspend counterpart of pci_reenable_device) the head of your
> > > tree ('git checkout -b test-branch 
> fa58d305d9925b01830e535896a7227a868a9e15').
> > > 
> > > If it does, please check the same for commit
> > > 571ff7584bb9e05fca0eb79752ae55a46faf3a98
> > > (PCI PM: Power-manage devices without drivers during suspend-resume).
> > 
> > Ah, please do the above with the USB commit
> > a0d4922da2e4ccb0973095d8d29f36f6b1b5f703 reverted.
> 
> Will do.
> 
> In the meantime I have bisected another problem: 
> commit 7503bfbae89eba07b46441a5d1594647f6b8ab7d
> Author: Mike Travis <travis@sgi.com>
> Date:   Sun Jan 4 05:18:09 2009 -0800
> 
>     cpumask: use work_on_cpu in acpi-cpufreq.c for drv_read and drv_write

that's reverted in upstream -git already.

	Ingo
