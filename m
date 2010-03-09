Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab0CISN5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 13:13:57 -0500
Received: from mail-yx0-f191.google.com ([209.85.210.191]:57575 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755227Ab0CISNz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 13:13:55 -0500
X-Greylist: delayed 12567 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Mar 2010 13:13:55 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ObJsdz/lQe7/8yRNk3229NxU9FyiJs9+ZlSmh05xLJRLiSDnp/PbblLqjoDnjo4IDu
         8GR4kj8arRiq4ULEkEUUyYOeQ2LSsDXSZIzEQxXqRGguuuzdNOhjU7YJVDfdRYW5XQ6B
         MfiYa+7M+9Xg5hBMz+4RunNyL65IoJRB0owjo=
MIME-Version: 1.0
In-Reply-To: <20100309181037.GB19814@core.coreip.homeip.net>
References: <20100301080342.GH765@core.coreip.homeip.net> <8bd0f97a1003090644p19fb7dacqe1f2fb3adee3fa7a@mail.gmail.com> 
	<20100309175107.GB23378@core.coreip.homeip.net> <8bd0f97a1003090958i741f4ffm3528450e89089e9@mail.gmail.com> 
	<20100309181037.GB19814@core.coreip.homeip.net>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 9 Mar 2010 13:13:34 -0500
Message-ID: <8bd0f97a1003091013q565f8b1bse66b48d9c9a25600@mail.gmail.com>
Subject: Re: [git pull] Input updates for 2.6.34-rc0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Robin Getz <rgetz@blackfin.uclinux.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 9, 2010 at 13:10, Dmitry Torokhov wrote:
> On Tue, Mar 09, 2010 at 12:58:24PM -0500, Mike Frysinger wrote:
>> On Tue, Mar 9, 2010 at 12:51, Dmitry Torokhov wrote:
>> > On Tue, Mar 09, 2010 at 09:44:08AM -0500, Mike Frysinger wrote:
>> >> On Mon, Mar 1, 2010 at 03:03, Dmitry Torokhov wrote:
>> >> > Hi Linus,
>> >> >
>> >> > Please pull from:
>> >> >
>> >> >        git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
>> >> > or
>> >> >        master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus
>> >> >
>> >> > to receive first round of updates for the input subsystem.
>> >>
>> >> i'm trying to figure out what the problem is with the ADXL34x and
>> >> AD714x drivers you seem to have accepted (at least, you didnt say
>> >> there was anything left for us to do).  i would have expected them to
>> >> be in 2.6.33/2.6.34 already, but it seems they arent moving now.  so
>> >> what's up ?
>> >
>> > I am still spooked by the fact that this is an accelerometer and does
>> > not have to be an input device but maybe used for different purposes as
>> > well.
>>
>> the AD714x is not an accelerometer, it's a capacitance touch sensor
>>
>
> OK, will dig it up.

thanks

>> i understand the ADXL34x is a bit wonky, but what else would you
>> propose ?  or just leave the driver in limbo forever until people
>> forget about it ?
>
> No, just till we have proper framework for it to be merged into.

that sounds fine, but is there actually something in progress for that
?  waiting for a framework no one is working on is the same in
practice ...
-mike
