Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab0CIR6s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 12:58:48 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:55647 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094Ab0CIR6p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 12:58:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=LPtMhjL5E7DiZW7TX5zVrCbi/FMf5zZAVybHh8oqGePyyxKKmM7tP+PE82/fnpa2r0
         miX0lN91781t7MCPF6HH5Tf2K6ZiTP1/pZduLUjjDVy2r3NkKnyeAKcDTUcmUIUoQsxG
         HjIedHlNjqRMaTGqcEsPxV5UrMHVGS7F4Ny4w=
MIME-Version: 1.0
In-Reply-To: <20100309175107.GB23378@core.coreip.homeip.net>
References: <20100301080342.GH765@core.coreip.homeip.net> <8bd0f97a1003090644p19fb7dacqe1f2fb3adee3fa7a@mail.gmail.com> 
	<20100309175107.GB23378@core.coreip.homeip.net>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 9 Mar 2010 12:58:24 -0500
Message-ID: <8bd0f97a1003090958i741f4ffm3528450e89089e9@mail.gmail.com>
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

On Tue, Mar 9, 2010 at 12:51, Dmitry Torokhov wrote:
> On Tue, Mar 09, 2010 at 09:44:08AM -0500, Mike Frysinger wrote:
>> On Mon, Mar 1, 2010 at 03:03, Dmitry Torokhov wrote:
>> > Hi Linus,
>> >
>> > Please pull from:
>> >
>> >        git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
>> > or
>> >        master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus
>> >
>> > to receive first round of updates for the input subsystem.
>>
>> i'm trying to figure out what the problem is with the ADXL34x and
>> AD714x drivers you seem to have accepted (at least, you didnt say
>> there was anything left for us to do).  i would have expected them to
>> be in 2.6.33/2.6.34 already, but it seems they arent moving now.  so
>> what's up ?
>
> I am still spooked by the fact that this is an accelerometer and does
> not have to be an input device but maybe used for different purposes as
> well.

the AD714x is not an accelerometer, it's a capacitance touch sensor

i understand the ADXL34x is a bit wonky, but what else would you
propose ?  or just leave the driver in limbo forever until people
forget about it ?
-mike
