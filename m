Return-Path: <linux-kernel-owner+w=401wt.eu-S933001AbXLUCJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933001AbXLUCJ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 21:09:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932693AbXLUCIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 21:08:14 -0500
Received: from mailbox2.myri.com ([64.172.73.26]:1909 "EHLO myri.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932399AbXLUCIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 21:08:12 -0500
Message-ID: <476B1FD8.4030306@myri.com>
Date: Thu, 20 Dec 2007 21:07:20 -0500
From: Loic Prylli <loic@myri.com>
User-Agent: Thunderbird/2.0.0.4 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: tcamuso@redhat.com
CC: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       "Chumbalkar, Nagananda" <Nagananda.Chumbalkar@hp.com>
Subject: Re: [Fwd: Re: [PATCH 0/5]PCI: x86 MMCONFIG]
References: <476A5FD0.4010804@redhat.com> <20071220172205.GB5636@suse.de> <476AB3B5.9080808@redhat.com> <20071220215719.GA8528@suse.de> <476AEE7B.6050708@redhat.com> <20071220224006.GA16855@suse.de> <476AF8EF.3060407@redhat.com>
In-Reply-To: <476AF8EF.3060407@redhat.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 12/20/2007 6:21 PM, Tony Camuso wrote:
>
> And the MMCONFIG problem with enterprise systems and workstations, where
> we do control the BIOS (for the most part), is due to known bugs in
> certain versions of certain chipsets, HT1000, AMD8132, among them, not
> the BIOS.



The lack of MMCONFIG support is indeed because some hypertransport
chipsets lack that support. But there are some BIOSes out there that are
advertising support for all busses in their MCFG acpi attribute (even
the busses managed by some amd8131 in a mixed nvidia-ck804/amd8131
motherboard), and the BIOS seems at least faulty for advertising a
capability that does not exist.


Loic

