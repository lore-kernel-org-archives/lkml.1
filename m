Return-Path: <linux-kernel-owner+w=401wt.eu-S1761905AbXIRSGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761905AbXIRSGJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 14:06:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760510AbXIRSFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 14:05:54 -0400
Received: from hu-out-0506.google.com ([72.14.214.233]:23783 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760651AbXIRSFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 14:05:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=tsSjjCeg67lVNDUkXH2B+Hc2vo/k+hUZVDplCsLfS6+3RKF5TtfzWyxLhXCL65cxjbJl6iJdxCJmiYbJRRMa0V+9g+st0WKVT/XMwdiz7uqcKNbnwxIVf8hxo6Y3KNV6ug8r6rQ9GSZUEZY+IABYCaLyFPK63IGTCnoTVti3Nw0=
Date: Tue, 18 Sep 2007 22:05:25 +0400
From: Sergey Dolgov <dolgovs@gmail.com>
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: Tejun Heo <htejun@gmail.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: ata_piix, laptop cdrom, ICH7: EH, limiting speed to PIO
Message-ID: <20070918180525.GA21130@slk.laptop>
References: <6bffcb0e0709120933p6d58127fv3c85076fe41daaca@mail.gmail.com> <20070912200706.GA2620@slk.laptop> <46E849B7.9040402@googlemail.com> <20070912212025.GB2620@slk.laptop> <46E8663E.3080205@googlemail.com> <46ED19F0.8060205@gmail.com> <ac0be4d70709170257o62e856f4re049c968ab5590a7@mail.gmail.com> <46EE66EA.3090902@gmail.com> <ac0be4d70709170505l6c4bba29pc8ad1c92fcb16ae9@mail.gmail.com> <f19298770709171018x6c4a150yfe6e490d7cc1721b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f19298770709171018x6c4a150yfe6e490d7cc1721b@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2007 at 09:18:26PM +0400, Alexey Zaytsev wrote:
> On 9/17/07, Sergey Dolgov <dolgovs@gmail.com> wrote:
> > On 9/17/07, Tejun Heo <htejun@gmail.com> wrote:
> >
> > [...]
> > > >>>> BTW, this only happens when using libata of course. The
> > > >>>> old CONFIG_IDE stuff works fine every time.
> > > >>> This maybe one of libata weirdness (I really don't get it why some hardware
> > > >>> works perfectly fine with an old IDE and don't work well with libata).
> > > >> Hmmm... Is MWDMA2 mode used with ide driver too?
> > > >>
> > > >
> > > > What's the best way to tell whether it does or not? (the log says
> > > > "selected mode 0x22", see below)
> > >
> > > Yes, that's MWDMA2.  Hmm... We're seeing many cases where MWDMA doesn't
> > > work with libata while it works fine with IDE but have no idea what's
> > > going on yet.  :-(
> > >
> >
> 
> This may be well a hardware problem. Same laptop (HP nx7300 GB848ES)
> works fine with either 2.6.22 and 2.6.23-rc. Maybe actually using the
> DVD is required to trigger the problem on the next reboot?

No, that is not required. The problem shows up on a fresh start from
powered-off state just as well.

> Sergey, btw, on this laptop I've observed lockups twice with the -rc5.
> After switching to 2.6.22 it was stable for at least one day. Can you
> confirm or refute this?

I've been using 2.6.23 rcs (rc3, rc6) since August, often for days
without rebooting the machine. Haven't seen any lockups (except the
ones on a return from suspend-to-RAM, but that's another story).

--
Sergey
