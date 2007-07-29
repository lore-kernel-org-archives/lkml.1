Return-Path: <linux-kernel-owner+w=401wt.eu-S1761940AbXG2KiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761940AbXG2KiT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 06:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761284AbXG2KiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 06:38:09 -0400
Received: from smtp106.plus.mail.re1.yahoo.com ([69.147.102.69]:41919 "HELO
	smtp106.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761291AbXG2KiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 06:38:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=sG3nB/D8p2DoCqUVZzqPOtITNeMC94J8LT/qs9uI8jdUJcIvBQ+TA7t440XiiErOz90BmV4ekvlm54rfPTKYM3guXv9MUPddgHp9iVU5cP0L9viZ5FJdSpmQRsLtNo2df7MtDPaBP6Pfa8m1oUANGkKAgZd8aToB/UQB4S+6JS8=  ;
X-YMail-OSG: E1uX398VM1kx68bAn6gRSM262cEvvTC8ZGvOTogMtzchu6Qg52W7TQAV6fzFQOqkB2GxCv7ryg--
Date: Sun, 29 Jul 2007 12:37:06 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Xudong Guan <xudong.guan@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Chuck Ebbert <cebbert@redhat.com>
Subject: Re: 2.6.23-rc1: no setup signature found...
Message-ID: <20070729103706.GA16780@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
References: <20070724112618.GA4431@gollum.tnic> <20070726150854.GA7034@xguan-laptop> <46A8BB6C.6050903@zytor.com> <20070726163053.GA4570@gollum.tnic> <46A8E3F9.5070809@zytor.com> <20070727013615.GC4570@gollum.tnic> <46A9753A.1010206@zytor.com> <20070729085059.GA10758@gollum.tnic> <20070729092402.GA2272@xguan-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070729092402.GA2272@xguan-laptop>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 29, 2007 at 10:24:02AM +0100, Xudong Guan wrote:
> Borislav Petkov wrote:
> > On Thu, Jul 26, 2007 at 09:31:54PM -0700, H. Peter Anvin wrote:
> > > If we can't reproduce the problem in simulation, that itself will tell
> > > us something very important.  If we *can* reproduce it in simulation, it
> > > will be vastly easier to debug.
> > 
> > [boris@gollum:10:34:25:qemu:9553)->  qemu -kernel /boot/2.6.22-4fd06960f120e02e9abc802a09f9511c400042a5-12 -append "root=/dev/hda" linux-0.2.img
> 
> You are using qemu itself as the kernel loader instead of your
> possible problematic grub on your harddisk. To duplicate the problem,
> you need to manually copy your grub and the kernel to linux-0.2.img
> and boot it with "qemu linux-0.2.img", although I am not sure
> exactly how to manually do this. Another way is to know your
> installation media that contains the copy of grub you are using,
> and use it to do an installation in qemu.

Right, this was too easy to be true. I now did:

qemu -hda /dev/hda -snapshot

and booted from the hd using the installed grub and the same kernel and it
_didn't_ boot showing again "no setup signature found... "

-- 
Regards/Gruﬂ,
    Boris.
