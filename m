Return-Path: <linux-kernel-owner+w=401wt.eu-S1751549AbXCDUGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549AbXCDUGi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 15:06:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbXCDUGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 15:06:37 -0500
Received: from wr-out-0506.google.com ([64.233.184.230]:52862 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbXCDUGh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 15:06:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Hc/KoJf8j0LuVa/0o0DsKE8e5j6xmuMO7ikaOwPNjBTccuyL2RH90UCSZ+SIfmO94XAabPEF39zhKObblxvqA0VbRmTUBBOeTvIvWKAPVxkiLk0KM3oLGoNEuZjc3PN1ifCdC4etl/yh9+4LXpF44FNuOTKd9OHpvacOEhEpQeg=
Message-ID: <f24d23310703041206u6fcb360ay69d61c56b6299fd4@mail.gmail.com>
Date: Mon, 5 Mar 2007 01:36:35 +0530
From: "debian developer" <debiandev@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [RFC] BadRAM still not ready for inclusion ? (was: Re: Free Linux Driver Development!)
In-Reply-To: <f24d23310703041204r2e729cc4ke93a9cbb70ef2e85@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1663310550@web.de>
	 <f24d23310703041204r2e729cc4ke93a9cbb70ef2e85@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The feature is not supported most prolly cos of lack of volunteers
pushing it into mainline, or it might be deprecated(is it??).
You are right in pointing out tht this could really save some ppl lots
of trouble.
am ready to help. pls contact for further queries
>
>
>
> On 3/5/07, devzero@web.de <devzero@web.de> wrote:
> >  Hello !
> >
> > There's some really nice feature-patch named BadRAM at http://rick.vanrein.org/linux/badram/index.html for years now, being announced around 2000 on this list, voted for inclusion in  2.3.99.
> >
> > BadRAM let's you tell the kernel to skip certain regions of ram, so you can continue using defective modules. Some older article describing BadRAM in more detail is at  http://www.linuxjournal.com/article/4489
> >
> > Some may tell "better buy some new ram" , but think of scenarios where ram being soldered onboard, modules not being available anymore due to special format - or people not having the money to buy new modules. Furthermore, this is good stuff for propaganda "Linux even works on machines with broken ram - no other operating system can do that!"
> >
> > It seems, that BadRAM is not being maintained very actively and the original author doesn`t seem to have the time pushing it into mainline, but i know it's actively being used by more then just a handful of people. Unfortunately there is no mailinglist to approve this and some "central point of communication" besides Rick van Rein doesn't seem to exist. There is a fork named BadMEM at  http://sourceforge.net/projects/badmem, Memtest86 also supporting BadRAM and i have seen LOTs of discussion about BadRAM on the net. Most of that discussion was due to problems getting it run with Kernel XYZ.
> >
> > Basically, this feature is a matter of adding/modifying 200 lines of code, so iŽm even more wondering, why it exists for more than 7 years and nothing happening here. I don`t know of any kernel patch which is comparable to this.
> >
> > This patch is real a ressource-saver - if being a standard Linux feature, it will save even more ressources: Saving user's time (because they are pulling their hair out to get this run with kernel XYZ) and also saving CPU time  (no compile orgies anymore), and thus waste of energy.
> >
> > Please comment if someone sees chances of getting this (after years of existance) into mainline and also please jump in to make the good thing happen !
> >
> > Historical patch collection at:
> >  http://rick.vanrein.org/linux/badram/download.html
> >
> > Most recent version of BadRAM should be:
> > http://rick.vanrein.org/linux/badram/software/BadRAM-2.6.19.1.patch
> >
> > Sorry for being a little bit "noisy" here, but I think BadRAM is a great feature and Linux could really benefit from that.
> >
> > regards
> > Roland K.
> > Sysadmin
> >
> >
> > List:       linux-kernel
> >  Subject:    Re: Free Linux Driver Development!
> > From:       devzero () web ! de
> > Date:       2007-02-04 21:37:33
> > Message-ID: 1605445807 () web ! de
> > [Download message RAW]
> >
> > First off, compliments to this announcement, I liked it very much!
> >
> > Some comment regarding those "volunteers, waiting to get some real work" :)
> >
> > > > OK, but why isn't your army of volunteers fixing them?
> >
> > > They don't know about them, or they don't have the hardware to test?
> > > Seriously, let the kernel-janitor's project know about any issues you
> > > have and they will be glad to jump on it.  Those people are just
> > > chomping a the bit to do something a bit bigger than "compiler warning
> > > cleanups" :)
> >
> > So many times i have seen good ideas brought up, kernel patches being written, posted \
> > to lkml, being developed outside mainline for a while and then being forgotten some \
> > time later due to lack of energy of some individual to get this into mainline.
> >
> > If there is an noticeably number of talented programmers (unfortunately, i`m not) , \
> > so why not "feeding" them the right way ? Where is those public and transparent and \
> > moderated Linux-Kernel "ToDo"- or "Keep an eye on"-list, sorted by priorities, with \
> > sort of a "vote for this feature"-button, so those guys have something they can pick \
> > up? There is so much great stuff and ideas out there where they could put their work \
> > onto or getting involved, it just needs to be found or sort of being "managed" a \
> > little bit better.
> >
> > For myself, i`m waiting for so quite some things to get "one step further", but they \
> > are more or less tied to some single individuals, for which you just cannot send some \
> >  "hey, what`s up with your project"-message every second day. The interest in many \
> > nice projects often is quite low and evolution quite slow, but not only because of \
> > the fact that they aren`t great, but more because of not getting widely known. It`s \
> > not always missing specs, it`s also some missing noise/feedback for different \
> > features or missing of some "driving force" to bring things forward. How should one \
> > developer know that somebody needs a feature if those who could probably need it \
> > don`t request it? Maybe just because of the fact that they even imagine that such \
> > feature would be possible ?
> >
> > Where is those efforts for fixing/integrating fantastic cowloop?
> > What about badram/badmem patch ?
> > Compressed Ccaching ?
> > Somebody helping with development of dm-loop or extend loop.c to support more than \
> > 256 devices ? Replacement of proprietary, unstable and unelegant vmware-lopp for \
> > being able to mount vmware .vmdk files ? Internal Spec for this is open, dm-userspace \
> > could be some infrastructure for this, but the author seems to have other \
> > priorities.... dm-cow, zfs-fuse - anybody ?
> > Kernel based target for AoE (Ata over Ethernet) ?  (there are two independent \
> > implementations, but both got stuck at some early experimental stage)
> >
> > Just my 2 cents.
> >
> > Roland K.
> > Sysadmin
> >
> > ps:
> > This isn`t meant to criticise any of you kernel developers since you`re doing \
> > fantastic work!
> > _______________________________________________________________________
> > Viren-Scan für Ihren PC! Jetzt für jeden. Sofort, online und kostenlos.
> > Gleich testen! http://www.pc-sicherheit.web.de/freescan/?mc=022222
> >
> > -
> >  To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at   http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
>
>
