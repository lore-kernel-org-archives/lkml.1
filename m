Return-Path: <linux-kernel-owner+w=401wt.eu-S1760121AbYG2Pql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760121AbYG2Pql (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 11:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759951AbYG2PqC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 11:46:02 -0400
Received: from outbound-mail-143.bluehost.com ([67.222.38.33]:41840 "HELO
	outbound-mail-143.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753930AbYG2PqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 11:46:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=O/D5EjBFaA2dvYZ0zrdFKZqkwXVxvtUzSB7Ia7Co0s+pZh4EBglyKNp8g8mXPMnGLYe/okO7ioBgIRDA/olrJ1uvli6IQWTxlVAF8o2mlHi/9sClRXTp9nudMVlNcUGQ;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] add iommu_num_pages helper function
Date: Tue, 29 Jul 2008 08:45:28 -0700
User-Agent: KMail/1.9.9
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, joerg.roedel@amd.com,
       mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       robert.richter@amd.com
References: <20080725134159.GA7493@amd.com> <20080729110749.728c54e6.sfr@canb.auug.org.au> <20080729112724.GA11276@elte.hu>
In-Reply-To: <20080729112724.GA11276@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807290845.28709.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 29, 2008 4:27 am Ingo Molnar wrote:
> * Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > Hi Ingo,
> >
> > On Sat, 26 Jul 2008 15:41:56 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> > > ok, i'll apply the 3 patches to tip/x86/iommu. As usual, feel free to
> > > send IOMMU cleanups/generalizations/fixes against tip/master:
> > >
> > >   http://people.redhat.com/mingo/tip.git/README
> >
> > So, I assume a patch created on July 25 is not destined for 2.6.27,
> > right?  Especially since it breaks another architecture build and has
> > only made it to linux-next on July 29 ... and needs more work given
> > the comments already on this patch.
>
> Correct, they were not intended for immediate upstream merging, they
> werent even in auto-x86-next so there was no meaningful linux-next
> exposure.
>
> I was surprised they went upstream via the PCI tree yesterday, just
> hours after i sent them over to Jesse and about an hour before -rc1 was
> released. [ Nor did intend the core/generic-dma-coherent bits to go
> upstream right before -rc1 - although those seem to be problem-free so
> far. ]
>
> I stopped sending non-urgent patches to Linus days ago, to let things
> calm down for a smooth -rc1 release.

Yeah I had a few things that I wanted to get upstream before -rc1, so I was 
probably a bit hasty with these bits (I thought they had had more soak time).  
Sounds like things are all worked out now though...

Thanks,
Jesse
