Return-Path: <linux-kernel-owner+w=401wt.eu-S1761523AbYJJQTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761523AbYJJQTU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 12:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758642AbYJJQTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 12:19:11 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:44396 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756034AbYJJQTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 12:19:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=xyWeeiSgAD73wEMAzUeZCyVurGK+hpdBFYG+sCGwf2DY1xBNujJ5LJurFi7ZYrsC60
         pjWs8ues6N+3TtoUui3mAq1zXbynbOKSdZiPoy1+SPCjfoL/NYi0rwHnRxao/ePl338e
         RQGUBrLrP7tlrJG6ZGG1zv5w+IVt9oY0fGlKM=
Message-ID: <86802c440810100919xf79f406x403988da7988edc9@mail.gmail.com>
Date: Fri, 10 Oct 2008 09:19:08 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Jesse Barnes" <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] pci: print out DMA mask info
Cc: "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>,
       grundler@parisc-linux.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
In-Reply-To: <200810100848.09557.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1223506943-6543-1-git-send-email-yinghai@kernel.org>
	 <20081009211837.GC18444@colo.lackof.org>
	 <20081010114002D.fujita.tomonori@lab.ntt.co.jp>
	 <200810100848.09557.jbarnes@virtuousgeek.org>
X-Google-Sender-Auth: b9da9687eee29695
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2008 at 8:48 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Thursday, October 9, 2008 7:40 pm FUJITA Tomonori wrote:
>> On Thu, 9 Oct 2008 15:18:37 -0600
>>
>> Grant Grundler <grundler@parisc-linux.org> wrote:
>> > On Wed, Oct 08, 2008 at 04:02:23PM -0700, Yinghai Lu wrote:
>> > > so can find out what is DMA mask is used for pci devices in addition to
>> > > default setting.
>> >
>> > I like the idea. I don't like the additional boot time output.
>> >
>> > But I'm thinking this could be an option to lspci.
>> > lspci already knows about the /sys tree. Can PCI export the two masks
>> > (dma_mask and dma_consistent_mask) and something like "lspci -td"
>> > would dump those in a nice way?
>> >
>> > Anyone else agree?
>>
>> Agreed.
>>
>> dma_mask and dma_consistent_mask is not useful for the
>> majority. Printing them at boot time doesn't make sense for me.
>>
>> Adding under sysfs and using lspci sounds reasonable if we really need
>> these information.
>
> Another option would be to add a 'warn_dma_mask=0xxxxxxxxx' boot option that
> would trigger in the actual DMA mask setting routines.  It would let you
> choose the mask you'd like to see warnings about.  Yinghai?
>

another command line parameter for debug?

anyway looking at dma_mask print out is interesting..., some uses 39,
and some use 44bits...

YH
