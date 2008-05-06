Return-Path: <linux-kernel-owner+w=401wt.eu-S1764317AbYEFR4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764317AbYEFR4X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 13:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753203AbYEFR4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 13:56:10 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:49681 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbYEFR4I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 13:56:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kg0cNhmwtKo74E6mVkknOmqo8SEseo5ApOJA0LjYNdULvd+4Qs+/9DmW5VSs6bkZ4E49aehmH3UCcnA5SmXluazYyN/T6HScK+BN6hC9mCMJmfWUQgH6qrV8DOesDVM5Wi2b3F3RLHQggA/n4jfXCBwBwJ1X77fsYGiht9Scyyg=
Message-ID: <c878e2290805061056k4b97513boa924eae90d649391@mail.gmail.com>
Date: Tue, 6 May 2008 19:56:05 +0200
From: "Kim Hansen" <kimhanse@gmail.com>
To: "Alex Dubov" <oakad@yahoo.com>
Subject: Re: tifm_7xx1: SD card is ignored
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <c878e2290804281343x21b7d4aau479bea16c0f7a2c6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <c878e2290804270359w4fe4392flc41a5fb074152572@mail.gmail.com>
	 <622387.91709.qm@web36701.mail.mud.yahoo.com>
	 <c878e2290804281343x21b7d4aau479bea16c0f7a2c6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 10:43 PM, Kim Hansen <kimhanse@gmail.com> wrote:
> On Sun, Apr 27, 2008 at 5:47 PM, Alex Dubov <oakad@yahoo.com> wrote:
>>
>>  --- Kim Hansen <kimhanse@gmail.com> wrote:
>>
>>  > I have the problem that the SD card slot does not work on my Toshiba
>>  > Protege M400 with my current kernel (2.6.24), it worked for me with
>>  > 2.6.18 but has been broken at least since 2.6.22.
>>  >
>>  > The problem is that nothing happens, dmesg is silent and I guess the
>>  > cause is that the driver does not see the hardware.
>>  >
>>  > How should I start debugging this?
>>  >
>>
>>  First, there's an option in the kernel config enabling debugging print-outs
>>  (called "MMC Debugging" under MMC). Enable it, recompile the modules and you'll
>>  get plenty of dmesg noise.
>
> I just downloaded 2.6.25 and compiled, and now it works. The 2.6.24
> kernel was from Debian, but I know that I also had the problem with
> 2.6.22 which I compiled myself. When 2.6.25 comes in Debian I will see
> if the problem is still there.

Unfortunately my machine crashes every hour or so when I run 2.6.25,
both with the home build kernel and with the Debian kernel, this makes
it impossible for me to do any real testing. The SD card works on the
home build kernel, but not on the Debian kernel, I will wait for
2.6.25 to become stable for me and then find the difference between
the two build that prevents the SD card from working on one of them.

I have also tried to compile 2.6.24 for myself now in order to see if
the SD would work there, it didn't, but I got a reaction in the dmesg
now:
  mmc0: card claims to support voltages below the defined range. These
will be ignored.
  mmc0: SDIO card claims to support the incompletely defined 'low
voltage range'. This will be ignored.
  mmc0: error -110 whilst initialising SDIO card

This might explain what the problem is?

Anyway, thanks for your time, I will just wait a little longer as it
almost works now,
-- 
Kim Hansen
Vadgårdsvej 3, 2.tv
2860 Søborg
Fastnet: 3956 2437 -- Mobil: 3091 2437
