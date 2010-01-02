Return-Path: <linux-kernel-owner+w=401wt.eu-S1752657Ab0ABJw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657Ab0ABJw0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 04:52:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599Ab0ABJwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 04:52:25 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:33405 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab0ABJwY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 04:52:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YlgFwXCp5NFl6ycIMDj2ciARCDG4hwPQqX+e4DFbUIATTf4ZI7LyMZcb8h3RaT0XMb
         CNatKYz6NZy5HO229+x6jMFDxEiugOPeadLjvHutnQnK7gRkIRmm/pYsw1nIjDnSykzc
         r1itY35WDAANOzRX4lo5kQxN5HM3SGFsf9b94=
MIME-Version: 1.0
In-Reply-To: <20100102025312.GC5788@core.coreip.homeip.net>
References: <3711715e0912310013u25e921cbqe6abb7c1621109e@mail.gmail.com>
	 <20100102025312.GC5788@core.coreip.homeip.net>
Date: Sat, 2 Jan 2010 10:52:22 +0100
Message-ID: <3711715e1001020152s626739daw6cdf2d7742a0d959@mail.gmail.com>
Subject: Re: [PATCH] HID: driver for BTC "Emprex 3009URF III Vista MCE Remote" 
	quirky remote
From: Wayne Thomas <waynethomas69@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: jkosina@suse.cz, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Sat, Jan 2, 2010 at 3:53 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> Hi Wayne,
>
> On Thu, Dec 31, 2009 at 09:13:22AM +0100, Wayne Thomas wrote:
>> HID: driver for BTC "Emprex 3009URF III Vista MCE Remote" quirky remote
>>
>> The Behavior Tech. Computer Corp. (BTC) remote branded as "Emprex 3009URF III
>> Vista Remote Controller" uses non-standard mappings for all of its 'special
>> purpose' keys (0xffbc usage page).  Applies cleanly to 2.6.30 and 2.6.32
>> (other versions not tested).
>> scripts/scriptpatch.pl reports 13 styling errors in hid-btc.c
>> ("break;" should be on trailing lines)
>> but have not changed them to maintain styling consistency with existing drivers.
>>
>
> I believe that this kind of mapping adjustment can be done via UDEV/HAL
> key remapping facilities, without need for the kernel patch.
>
> Thanks.
>
> --
> Dmitry
>

I'll look into what you have suggested.  The issue is identical to
that of the TopSeed remote, which is why I used this method.  If this
is the case I assume that the topseed driver (and any others) should
also be removed?

Cheers
Wayne
