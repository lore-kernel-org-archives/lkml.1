Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692Ab0AYSr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab0AYSr2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 13:47:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754676Ab0AYSr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 13:47:27 -0500
Received: from outbound-mail-313.bluehost.com ([67.222.54.6]:54711 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752384Ab0AYSr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 13:47:26 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=er9Sdh5qn/dEddwSHJ+xzc70g2zJLrsVlnhgDPbkQfpRKiRWIS6tJGtIA6bc/TSFXZS2e32FmheNgMYrQ+IWGrvldj4MiuaRKEVpsWgimtqT4CUY1Pks+1lAoxaY8uUL;
Date: Mon, 25 Jan 2010 10:47:17 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for January 21
Message-ID: <20100125104717.244e5140@jbarnes-piketon>
In-Reply-To: <4B58DC99.9040302@imap.cc>
References: <20100121165713.7b8a746d.sfr@canb.auug.org.au>
	<20100121131339.5e86dfef.akpm@linux-foundation.org>
	<4B58DC99.9040302@imap.cc>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jan 2010 00:00:41 +0100
Tilman Schmidt <tilman@imap.cc> wrote:

> Am 21.01.2010 22:13 schrieb Andrew Morton:
> > On Thu, 21 Jan 2010 16:57:13 +1100
> > Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > 
> >> I have created today's linux-next tree at
> >> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> > 
> > It includes this screwed up commit:
> > 
> > :commit e303d9eadc64907535a0a104afa5871d2b83275e
> > :Author:     Tilman Schmidt <tilman@imap.cc>
> > :AuthorDate: Thu Jan 14 23:18:41 2010 +0100
> > :Commit:     Jesse Barnes <jbarnes@virtuousgeek.org>
> > :CommitDate: Fri Jan 15 10:08:07 2010 -0800
> > :
> > :    PCI/ISDN: push deprecated pci_find_device() function to last
> > user (isdn) :    
> > :    The ISDN4Linux HiSax driver family contains the last remaining
> > users of :    the deprecated pci_find_device() function. This patch
> > creates a private :    copy of that function in HiSax, and removes
> > the now unused global :    function together with its controlling
> > configuration option, :    CONFIG_PCI_LEGACY.
> > :    
> > :    Signed-off-by: Tilman Schmidt <tilman@imap.cc>
> > :    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
> > 
> > It adds a bunch of files which are compile-time generated:
> > 
> > include/linux/autoconf.h
> > include/linux/bounds.h
> > include/linux/compile.h
> > include/linux/utsrelease.h
> 
> That's not the patch I submitted. Mine did not add any new files.
> 
> What's more, I've since submitted a new version, fixing the reported
> build failure with CONFIG_PCI=n:
> 
> Subject: [PATCH/v2] pci: push deprecated pci_find_device() function
> to last user Message-Id:
> <20100118162410.4562840108@xenon.ts.pxnet.com> Date: 	Mon, 18
> Jan 2010 17:24:10 +0100 (CET)
> 
> So please drop the patch above, and include the latter one instead.

Ok pushed what should be the fixed up one (your v2 with fuzz fixed up).

-- 
Jesse Barnes, Intel Open Source Technology Center
