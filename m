Return-Path: <linux-kernel-owner+w=401wt.eu-S1756776AbXLTTEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776AbXLTTEq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 14:04:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbXLTTEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 14:04:38 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438AbXLTTEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 14:04:38 -0500
Message-ID: <476ABCBF.8090006@redhat.com>
Date: Thu, 20 Dec 2007 14:04:31 -0500
From: Tony Camuso <tcamuso@redhat.com>
Reply-To: tcamuso@redhat.com
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Loic Prylli <loic@myri.com>
CC: Matthew Wilcox <matthew@wil.cx>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [Fwd: Re: [PATCH 0/5]PCI: x86 MMCONFIG]
References: <476A5FD0.4010804@redhat.com> <20071220172205.GB5636@suse.de> <20071220173528.GE29690@parisc-linux.org> <476AAE99.7090301@redhat.com> <20071220181603.GF29690@parisc-linux.org> <476AB920.7040604@myri.com>
In-Reply-To: <476AB920.7040604@myri.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Loic Prylli wrote:

> Always using type 1 for accesses below 256 bytes looks like a very very
> attractive solution
> 
> I know we had a lot of older kernels over the last two years that we
> patched like that (we needed MMCONFIG for our own device development
> purposes, but we also needed our machines to boot and discover all
> devices reliably). Recent kernels works fine out of the box on all
> hardware we have, but all this sometimes tricky and apparently endless
> work (in big part because of buggy BIOSes) about MMCONFIG would probably
> become relatively easy by limiting the aim to have MMCONFIG work when it
> is required (for cfg-space accesses >= 256).
> 
> 
> Loic
> 
Hmmm... I think I like this solution.

It may be easier to implement than the solution I posted.

Also, this solution also would allow us to remove the unreachable_devices()
routine and bitmap.

Does anybody see a down side to this?
