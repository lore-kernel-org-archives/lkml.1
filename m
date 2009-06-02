Return-Path: <linux-kernel-owner+w=401wt.eu-S1752975AbZFBS51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975AbZFBS51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 14:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbZFBS5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 14:57:20 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:57514 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbZFBS5T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 14:57:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ndzu59R+llzWl1hYWTqzKgsSzwHeYSoWjG8Wr1kP4CWeI3w29yQKm4s1ZL9S61KXJH
         YVwXkgLwrU/GU4aFlsqaNNUAGT0+1U/BVXLTfVqZXmMZC24umr8v0iNPfRk4ZVnQRw8Y
         knVRYNJs8j/ePTY1JL9p9g+fLR8UFf5VZLpUM=
MIME-Version: 1.0
In-Reply-To: <20090602141529.GA8325@emlix.com>
References: <E1LfGwO-0007Kq-6c@mailer.emlix.com>
	 <20090310073350.GH10393@linux-sh.org>
	 <20090402135343.d18d17a5.akpm@linux-foundation.org>
	 <20090409142553.GA3330@emlix.com> <20090505140847.GB25409@emlix.com>
	 <20090527114955.GA23343@emlix.com>
	 <20090527134357.601c3c87.akpm@linux-foundation.org>
	 <20090528000801.GA30594@linux-sh.org>
	 <20090527171631.ed4de515.akpm@linux-foundation.org>
	 <20090602141529.GA8325@emlix.com>
Date: Tue, 2 Jun 2009 14:57:18 -0400
Message-ID: <8bd0f97a0906021157pfad795dg9fc0ac0ed4f85d1c@mail.gmail.com>
Subject: Re: [PATCH -v3] flat: fix data sections alignment
From: Mike Frysinger <vapier.adi@gmail.com>
To: Oskar Schirmer <os@emlix.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Paul Mundt <lethal@linux-sh.org>, jw@emlix.com, dhowells@redhat.com,
       rmk@arm.linux.org.uk, cooloney@kernel.org, geert@linux-m68k.org,
       gerg@uclinux.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 2, 2009 at 10:15, Oskar Schirmer wrote:
> On Wed, May 27, 2009 at 17:16:31 -0700, Andrew Morton wrote:
>> On Thu, 28 May 2009 09:08:02 +0900
>> Paul Mundt <lethal@linux-sh.org> wrote:
>> > On Wed, May 27, 2009 at 01:43:57PM -0700, Andrew Morton wrote:
>> > > The patch had a fairly shaky start and it's been unclear to me that
>> > > everyone is happy with it and has tested it.
>> > >
>> > >  arch/arm/include/asm/flat.h      |    3 --
>> > >  arch/blackfin/include/asm/flat.h |    1
>> > >  arch/h8300/include/asm/flat.h    |    1
>> > >  arch/m32r/include/asm/flat.h     |    1
>> > >  arch/m68k/include/asm/flat.h     |    1
>> > >  arch/sh/include/asm/flat.h       |    1
>> > >  fs/binfmt_flat.c                 |   46 ++++++++++++++++++++++++++-------------
>> > >
>> > > I guess ARM is the major architecture amongst that lot.  Have Russell
>> > > and co had a decent look through this?
>> > >
>> > The problem here is that the ARM nommu people seem to have disappeared
>> > shortly after getting their changes merged. I see no activity within the
>> > kernel for ARM nommu since 2006.
>>
>> heh, OK.  Oskar touched it last, so he's now ARM nommu maintainer.
>
> Well, I'ld need some test device for that purpose.
> Someone around who can provide one?

seems a bit odd for a maintainer to not have any hardware ... at any
rate, dont you have an ARM system ?  cant you just disable support for
the MMU ?
-mike
