Return-Path: <linux-kernel-owner+w=401wt.eu-S1765049AbXLTXVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765049AbXLTXVw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 18:21:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759471AbXLTXVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 18:21:31 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758652AbXLTXVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 18:21:30 -0500
Message-ID: <476AF8EF.3060407@redhat.com>
Date: Thu, 20 Dec 2007 18:21:19 -0500
From: Tony Camuso <tcamuso@redhat.com>
Reply-To: tcamuso@redhat.com
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       "Chumbalkar, Nagananda" <Nagananda.Chumbalkar@hp.com>
Subject: Re: [Fwd: Re: [PATCH 0/5]PCI: x86 MMCONFIG]
References: <476A5FD0.4010804@redhat.com> <20071220172205.GB5636@suse.de> <476AB3B5.9080808@redhat.com> <20071220215719.GA8528@suse.de> <476AEE7B.6050708@redhat.com> <20071220224006.GA16855@suse.de>
In-Reply-To: <20071220224006.GA16855@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> 
> Sure, I realize this, but it solves the problem in one way for broken
> hardware, such that it at least allows it to work, right?  It also
> provides a better incentive for the manufacturer to fix their bios,
> which as you are on-site at HP, it would seem odd that they would just
> not do that instead of trying to work around this in the kernel...
> 
> thanks,
> 
> greg k-h

I don't think that many OEMs have that much control over the BIOS in
their "value lines".
:)

And the MMCONFIG problem with enterprise systems and workstations, where
we do control the BIOS (for the most part), is due to known bugs in
certain versions of certain chipsets, HT1000, AMD8132, among them, not
the BIOS.

Anyway, we are devising better ways to deal with these anomalies
than blacklists and telling customers to use "pci=nommconf"

And we're bringing them to the community for discussion, improvement,
and, we hope, acceptance.

