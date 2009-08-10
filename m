Return-Path: <linux-kernel-owner+w=401wt.eu-S1754843AbZHJDsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbZHJDsX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 23:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753142AbZHJDsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 23:48:23 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:51529 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbZHJDsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 23:48:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eQ5+yWFVJftIoZDNUyw59Rg1gJvh4AfBa6my/IPIG6ag5owJmvbdn2II+FJOraScOr
         MZTO8KiLuaApTNrJO5UfX+3S965oaZ/dec+oEZz3syLJhb7AEs6TRrwfNHmGh46huQW8
         Dmc8RioJxKdUoUKoOLuU7EHzjgmCO+aHuQspI=
MIME-Version: 1.0
In-Reply-To: <4A7F1F2C.3080809@mnementh.co.uk>
References: <Pine.LNX.4.64.0907170842050.4731@axis700.grange>
	 <4A716F1C.2050805@mnementh.co.uk>
	 <Pine.LNX.4.64.0907301246330.4462@axis700.grange>
	 <4A71F2A5.4060206@mnementh.co.uk>
	 <aec7e5c30908021952j7947b513w7d62f2c4d87bd3c5@mail.gmail.com>
	 <4A787C2C.5070000@mnementh.co.uk>
	 <aec7e5c30908041908p568f413albef7dede3fd2cb83@mail.gmail.com>
	 <4A798A4B.4000901@mnementh.co.uk>
	 <Pine.LNX.4.64.0908051702180.5802@axis700.grange>
	 <4A7F1F2C.3080809@mnementh.co.uk>
Date: Mon, 10 Aug 2009 12:48:22 +0900
Message-ID: <aec7e5c30908092048m393da810s72138fd18bf35e6f@mail.gmail.com>
Subject: Re: MMC / MFD / Clocks
From: Magnus Damm <magnus.damm@gmail.com>
To: Ian Molton <ian@mnementh.co.uk>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       pHilipp Zabel <philipp.zabel@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org, Pierre Ossman <drzeus@drzeus.cx>,
       Magnus Damm <damm@opensource.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ian,

Thanks for your work on this!

On Mon, Aug 10, 2009 at 4:10 AM, Ian Molton<ian@mnementh.co.uk> wrote:
> Hi guys,
>
> I've done a bit more on the clocking code - it compiles now, but the mmc
> driver needs to pass some more data out than it does right now before the
> code will actually work.

Looking good! I will most likely use NULL for ->set_pwr() and
->set_no_clk_div() and from that perspective the patch looks not so
far from complete already.

> Unless I hear any other comments, this is the direction the driver will
> take.

Good direction!

The office is closed this week due to holidays, but after that i'll
dust off my little Fluke Scopemeter and measure the frequency. Not
sure if there is any divisor that modifies the input clock for the
hardware block before we get a change to control it using
CTL_SD_CARD_CLK_CTL.

Anyway, thanks a lot for your help. Please CC this gmail address when
you update the patch.

Cheers,

/ magnus
