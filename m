Return-Path: <linux-kernel-owner+w=401wt.eu-S1754894AbYIIFG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbYIIFG1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 01:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbYIIFGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 01:06:18 -0400
Received: from outbound-mail-115.bluehost.com ([69.89.24.5]:54064 "HELO
	outbound-mail-115.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751130AbYIIFGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 01:06:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=hrUWZkzw+2iDWowwp+pPMUMzjs9FFmiggmDrCK9h+zr/AdTowFDyxkoqUVhbyoHtVKzOOBdMw0bHaHoMeNroFzfG5wA+MDj7O8d7TFj77GFSlRR76+1ZJIxMgoBvG1vI;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [2.6 patch] m68k: remove the dead PCI code
Date: Mon, 8 Sep 2008 22:06:07 -0700
User-Agent: KMail/1.9.9
Cc: Adrian Bunk <bunk@kernel.org>, Greg Ungerer <gerg@snapgear.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, Linux/m68k <linux-m68k@vger.kernel.org>
References: <20080819134718.GH8852@cs181140183.pp.htv.fi> <20080831161016.GE3695@cs181140183.pp.htv.fi> <Pine.LNX.4.64.0809061422510.4138@anakin>
In-Reply-To: <Pine.LNX.4.64.0809061422510.4138@anakin>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809082206.08031.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 12.108.5.2 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, September 06, 2008 5:23 am Geert Uytterhoeven wrote:
> On Sun, 31 Aug 2008, Adrian Bunk wrote:
> > This patch removes the no longer used m68k PCI code.
> >
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> >
> > --- a/include/asm-m68k/pci.h
> > +++ b/include/asm-m68k/pci.h
> >
> > -/* The PCI address space does equal the physical memory
> > - * address space.  The networking and block device layers use
> > - * this boolean for bounce buffer decisions.
> > - */
>
> I'd like to keep this comment, as the #define is still there.
> Is that OK for you?
>
> >  #define PCI_DMA_BUS_IS_PHYS	(1)

Btw, I'm assuming you'll be queuing this up, Geert.  Let me know if you want 
to do otherwise...

Thanks,
Jesse
