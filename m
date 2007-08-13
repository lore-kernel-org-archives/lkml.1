Return-Path: <linux-kernel-owner+w=401wt.eu-S1761882AbXHMExQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761882AbXHMExQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 00:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbXHMExF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 00:53:05 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:19804 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbXHMExC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 00:53:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VJV7xHZiRpjcM9FG0O2MWKhZgp4sqql3SG/NDNBWxwV/u/YCnyAu0szWjJngMW3ChCiO4usoKwV2DjDpQKe0rcDCau6TgwH6wiqRkv3qUl1OhXsWBiOq4ST+mjy6R8uKQ5FponrAopbB1HAQ+CDmiNbb0MldMU1pexkJghuknwQ=
Message-ID: <9e0cf0bf0708122153q47a49e6ck5e80a8353172bd44@mail.gmail.com>
Date: Mon, 13 Aug 2007 07:53:01 +0300
From: alon.barlev@gmail.com
To: "Michael Chang" <thenewme91@gmail.com>
Subject: Re: encrypted hibernation (was Re: Hibernation considerations)
Cc: "Dr. David Alan Gilbert" <linux@treblig.org>,
       "Pavel Machek" <pavel@ucw.cz>, "Vojtech Pavlik" <vojtech@suse.cz>,
       seife@suse.de, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       "Alan Stern" <stern@rowland.harvard.edu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       "Jeremy Maitin-Shepard" <jbms@cmu.edu>,
       "Kyle Moffett" <mrmacman_g4@mac.com>,
       "Nigel Cunningham" <nigel@nigel.suspend2.net>,
       "pm list" <linux-pm@lists.linux-foundation.org>, david@lang.hm,
       "Al Boldi" <a1426z@gawab.com>
In-Reply-To: <b14e81f00708121930n7d9eab99r6fa776120c6287c1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707151433.34625.rjw@sisk.pl> <20070715125855.GA1737@gallifrey>
	 <200707160038.12943.rjw@sisk.pl> <20070729065352.GB17084@suse.cz>
	 <20070805195628.GA1947@elf.ucw.cz> <20070811234356.GA19183@gallifrey>
	 <b14e81f00708121930n7d9eab99r6fa776120c6287c1@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

We already have a sample at:
http://wiki.tuxonice.net/EncryptedSwapAndRoot
It stores the keys of mounted partitions on an encrypted swap, which
has the same encryption with different keyset.
It also shows how to resume from encrypted swap, And you can
optionally store the keys on hardware device such as smartcards.

Best Regards,
Alon Bar-Lev

On 8/13/07, Michael Chang <thenewme91@gmail.com> wrote:
> On 8/11/07, Dr. David Alan Gilbert <linux@treblig.org> wrote:
> > * Pavel Machek (pavel@ucw.cz) wrote:
> > > Hi!
> > >
> > > > > > Two things which I think would be nice to consider are:
> > > > > >    1) Encryption - I'd actually prefer if my luks device did not
> > > > > >        remember the key accross a hibernation; I want to be forced
> to
> > > > > >        reenter the phrase.  However I don't know what the best
> thing
> > > > > >        to do to partitions/applications using the luks device is.
> > > > >
> > > > > Encryption is possible with both the userland hibernation (aka
> uswsusp) and
> > > > > TuxOnIce (formerly known as suspend2).  Still, I don't consider it
> as a "must
> > > > > have" feature for a framework to be generally useful (many users
> don't use it
> > > > > anyway).
> > > >
> > > > If a user uses an encrypted filesystem, then he also needs an
> encrypted
> > > > swap and encrypted hibernation image: Otherwise the fileystem
> encryption
> > > > is not very useful.
> > >
> > > Actually, we can do most of that stuff already.
> > >
> > > We can encrypt filesystems, encrypt swaps (LVM), and encrypt
> hibernation.
> >
> > But can you do what my original question was; find a way to lose a luks
> > encrypted device key and cleanly unmount the filesystem that was
> > using it?  (and preferably put it all back together after resume).
> >
>
> If you lose the device key, how are you going to get luks to find it
> again when resuming? Wouldn't it make more sense to have it remember
> the key? I can't see it being advisable to allow input or similar
> before resume has completed...
>
> --
> Michael Chang
>
> Please avoid sending me Word or PowerPoint attachments. Send me ODT,
> RTF, or HTML instead.
> See http://www.gnu.org/philosophy/no-word-attachments.html
> Thank you.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
