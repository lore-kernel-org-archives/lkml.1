Return-Path: <linux-kernel-owner+w=401wt.eu-S1760256AbYHUPHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760256AbYHUPHl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 11:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756740AbYHUPH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 11:07:28 -0400
Received: from outbound-mail-159.bluehost.com ([67.222.39.39]:36909 "HELO
	outbound-mail-159.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756610AbYHUPH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 11:07:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=dgHs3G1zNC2eiB5W2eY9hfi5X/6M5tM2l7Hx1K7csGZGO8b9M9/4NhWfrhiq/y6mnd6Yawb/CiyYYe4/c9vVhEtY/7k9SKWb+PEaz/GgC4ImPpKm1E4GWR+REuoU1bKn;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 0/8] x86 dma_*_coherent rework patchset v2
Date: Thu, 21 Aug 2008 08:07:05 -0700
User-Agent: KMail/1.9.9
Cc: mingo@elte.hu, joerg.roedel@amd.com, mingo@redhat.com, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, muli@il.ibm.com
References: <20080820094612.GA28492@elte.hu> <20080821120011.GD5615@elte.hu> <20080821231720S.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080821231720S.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808210807.05996.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 21, 2008 7:16 am FUJITA Tomonori wrote:
> > > > Jesse, Fujita-san, do these changes look fine to you?
> > >
> > > Yeah, I'll let you push this time. :)
> > >
> > > Signed-off-by:  Jesse Barnes <jbarnes@virtuousgeek.org>
> >
> > with a v2.6.28 ETA, right?
>
> Surely, this patchset should be for 2.6.28.
>
> Can you send this via the x86 tree instead of pci?
>
> - IOMMU code is arch stuff rather than pci.
> - We can avoid a mistake such as the previous one.

Yeah I was thinking 2.6.28 too, via the x86 tree.  The problem last time was 
that I sent it too soon (I misunderstood Ingo when he said it was ready) so 
we broke the build on some non-x86 platforms.  I don't think that'll be an 
issue this time, but we may as well push through x86 anyway; I agree that 
IOMMU is really a platform feature more than a PCI one.

Jesse
