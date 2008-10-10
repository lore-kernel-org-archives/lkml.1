Return-Path: <linux-kernel-owner+w=401wt.eu-S1761406AbYJJPsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761406AbYJJPsl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 11:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759592AbYJJPsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 11:48:31 -0400
Received: from outbound-mail-121.bluehost.com ([67.222.38.21]:48035 "HELO
	outbound-mail-121.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759130AbYJJPsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 11:48:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=nSuVLO37EK7SaeVT100AWlChiwLAev5aQ0lDLku3hLazI9R8tSL9YtTa1n9/Bub1ZV0sZva3oBtzGaD40YaSXm5Idg5OOjDc97yUd/zhZDZT9/lSto/1mgDnA3uUy0Nx;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] pci: print out DMA mask info
Date: Fri, 10 Oct 2008 08:48:08 -0700
User-Agent: KMail/1.9.10
Cc: grundler@parisc-linux.org, yinghai@kernel.org, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
References: <1223506943-6543-1-git-send-email-yinghai@kernel.org> <20081009211837.GC18444@colo.lackof.org> <20081010114002D.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081010114002D.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810100848.09557.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 9, 2008 7:40 pm FUJITA Tomonori wrote:
> On Thu, 9 Oct 2008 15:18:37 -0600
>
> Grant Grundler <grundler@parisc-linux.org> wrote:
> > On Wed, Oct 08, 2008 at 04:02:23PM -0700, Yinghai Lu wrote:
> > > so can find out what is DMA mask is used for pci devices in addition to
> > > default setting.
> >
> > I like the idea. I don't like the additional boot time output.
> >
> > But I'm thinking this could be an option to lspci.
> > lspci already knows about the /sys tree. Can PCI export the two masks
> > (dma_mask and dma_consistent_mask) and something like "lspci -td"
> > would dump those in a nice way?
> >
> > Anyone else agree?
>
> Agreed.
>
> dma_mask and dma_consistent_mask is not useful for the
> majority. Printing them at boot time doesn't make sense for me.
>
> Adding under sysfs and using lspci sounds reasonable if we really need
> these information.

Another option would be to add a 'warn_dma_mask=0xxxxxxxxx' boot option that 
would trigger in the actual DMA mask setting routines.  It would let you 
choose the mask you'd like to see warnings about.  Yinghai?

-- 
Jesse Barnes, Intel Open Source Technology Center
