Return-Path: <linux-kernel-owner+w=401wt.eu-S1753652AbYF1D2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652AbYF1D2i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 23:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbYF1D22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 23:28:28 -0400
Received: from elasmtp-dupuy.atl.sa.earthlink.net ([209.86.89.62]:59301 "EHLO
	elasmtp-dupuy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752374AbYF1D21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 23:28:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=J2ZrGK5YD9lhd1MLDYWUFxqunT+AMRxku/k8uSJQcTiYnacKq3P4tmXkVNEgPQMD;
  h=Received:Message-ID:From:To:Cc:References:Subject:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:X-MSMail-Priority:X-Mailer:X-MimeOLE:X-ELNK-Trace:X-Originating-IP;
Message-ID: <05d401c8d8cf$04627390$0125a8c0@wednesday>
From: "jdow" <jdow@earthlink.net>
To: "Willy Tarreau" <w@1wt.eu>
Cc: "Matthew" <jackdachef@gmail.com>, <greg@kroah.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
References: <e85b9d30806230602m10b5aa06m2f1c83e1a90a7dac@mail.gmail.com> <20080623132118.GC1369@1wt.eu> <01ca01c8d715$1b127a60$0125a8c0@wednesday> <20080625231107.GA21889@1wt.eu>
Subject: Re: [ANNOUNCE] Position Statement on Linux Kernel Modules
Date: Fri, 27 Jun 2008 20:28:21 -0700
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
X-ELNK-Trace: bb89ecdb26a8f9f24d2b10475b571120bae5cdb0324e4a3a3ccb1878b08019fb852111c7a8f4e425350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 68.183.103.112
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Willy Tarreau" <w@1wt.eu>
Sent: Wednesday, 2008, June 25 16:11


> On Wed, Jun 25, 2008 at 03:45:01PM -0700, jdow wrote:
>> From: "Willy Tarreau" <w@1wt.eu>
>> Sent: Monday, 2008, June 23 06:21
>> 
>> 
>> >On Mon, Jun 23, 2008 at 03:02:58PM +0200, Matthew wrote:
>> >>Hi Greg,
>> >>
>> >>I largely agree to this statement,
>> >>
>> >>there are however some downsides if you're preventing driver
>> >>manufacturers (e.g. nvidia, ...) from the possibility to offer their
>> >>customers proprietary drivers:
>> >>
>> >>1) One big and important point for me (and more and more future
>> >>linux-users) is powersaving features on GPUs like powermizer (by
>> >>nvidia) and powerplay (by AMD/ATI) or other hardware. I haven't seen
>> >>this working on newer graphics cards models with the opensource
>> >>drivers to the present day :(
>> >
>> >I think that's one of the reasons of Greg's post.
>> >
>> >(...)
>> >>if those companies can't use their own closed proprietary drivers
>> >>utilizing patented routines they are "forced" to use
>> >
>> >You're wrong here. If they have patented routines, they don't need
>> >their drivers to be closed, since there routines are protected by
>> >patents. And even if they are not patented, not releasing the source
>> >will not prevent a competitor from disassembling the code anyway.
>> >So there's really no point in remaining closed. Some of them might
>> >have signed NDAs before using some technologies, but by this time,
>> >they should have sorted that our.
>> 
>> Willy, you make a bold assertion here. Your assertion would hold a
>> lot more weight if you defended it with some facts.
>> 
>> >>they might think over it and switch to another operating system ...
>> >
>> >Do you know many products with closed Linux drivers which are not
>> >supported by at least one closed OS ? If they chose to support
>> >Linux, it's not for your pleasure, just because they know they will
>> >sell 5-10% more when a penguin is stuck on the box.
>> 
>> That is why there are the closed, and flakey, drivers for so many
>> products. Rather than make ideological assertions sit down and prove
>> your points. Address cases where there is an intellectual property
>> holder involved who has chosen Trade Secret rather than Patent as a
>> protection on their proprietary code. Show how they will stay in
>> business if they give away their code.
> 
> Your statements clearly indicate that you have never worked yet and
> are slowly discovering the business world. I would like to return
> the challenge to you : show me one software company still in business
> and making profit who has not set a few patents on (provably obvious)
> methods they rely on. Trade secrets don't work anymore because once
> discovered, you're attacked by their patent holder (since everything
> is patented in this crappy world).
> 
> There are no trade secrets in software, everything is disassemblable
> and decompilable. There are no trade secrets in hardware. Chips get
> acid-washed, photographed, recomposed and decompiled every day. Trying
> to hide a hardware trade secret inside a binary driver is completely
> silly and useless.
> 
>> Presume that their modules are
>> in clean enough shape that making money with a profitable service desk
>> is not going to fly.
> 
> Releasing source costs less than maintaining and releasing binaries for
> every version of every distro.
> 
> However, what *does* happen is that some editors don't want to see
> their sources released as GPL or BSD and get stolen^Wcleaned up by
> someone who pretends to provide a clean rewrite by playing cut'n'paste.
> But I don't think it is a real problem in the driver world. Once the
> driver gets merged, it's on the rails.

I'll bet I am older than you, perhaps by a factor of two, from your
rhetoric.

Yes, chips get decompiled and then the instructions that run on the
chips get decompiled. The time it takes to do that is the period that
the trade secret holds. I don't think that any of the chip manufacturers
for widgets that have proprietary drivers are building in hard protection
of the chip's features, yet. So I'll give you that scenario. But I note
that it is not a low man hours proposition. The time would probably be
better spent building upon the hardware you already have.  If it wasn't
then nVidia and ATI would be running on the same GPUs.

(For the record I have been involved with chips that "resist" efforts to
figure out what is on them. Once wrapped in their "box" efforts to take
them apart were supposed to effectively destroy the chip such that the
code stored on it was not going to be readable. It was a little GPS
receiver encryption tool in the 80s.)

{^,^}   Joanne formally sticks her tongue out at you for your patronizing
        air. Religious zealots are tiresome.
