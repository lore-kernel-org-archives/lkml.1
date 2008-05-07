Return-Path: <linux-kernel-owner+w=401wt.eu-S1756158AbYEGNWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158AbYEGNWX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 09:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751851AbYEGNWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 09:22:01 -0400
Received: from web36706.mail.mud.yahoo.com ([209.191.85.40]:34592 "HELO
	web36706.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751440AbYEGNV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 09:21:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=j3iL/SjLeN+wMkqlViiP3yO9nmoiavBg6dr3TIv/mifZ0tpXIf2J/Xed30zmJghkmvG410tqYqiEpQI+Ye8bZNzOehAWWurXLl6wmYRM3ITBEhTNGdU8Vpk9Kq58InwHrjg25jszLwDZd7KoZLj+i5rwHSoY5dSDWjo0qUgx4XA=;
X-YMail-OSG: fNg_KqUVM1nqCTNoJz1yQ.peKkK2D9LakbKsBONd8VsYyAF9vZD2qA9_D1XdWHWhCojBI2a5pEPYP1J2GAHul2a4wWGAreAl9jDOgVKbHM.QbwKaIE7kjv3Rzw--
Date: Wed, 7 May 2008 06:21:55 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: tifm_7xx1: SD card is ignored
To: Kim Hansen <kimhanse@gmail.com>
Cc: linux-kernel@vger.kernel.org, drzeus@drzeus.cx
In-Reply-To: <c878e2290805061056k4b97513boa924eae90d649391@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <202777.76958.qm@web36706.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Unfortunately my machine crashes every hour or so when I run 2.6.25,
> both with the home build kernel and with the Debian kernel, this makes
> it impossible for me to do any real testing. The SD card works on the
> home build kernel, but not on the Debian kernel, I will wait for
> 2.6.25 to become stable for me and then find the difference between
> the two build that prevents the SD card from working on one of them.

As you could guess, I have no idea how's debian kernel different from the stock
one.

> 
> I have also tried to compile 2.6.24 for myself now in order to see if
> the SD would work there, it didn't, but I got a reaction in the dmesg
> now:
>   mmc0: card claims to support voltages below the defined range. These
> will be ignored.
>   mmc0: SDIO card claims to support the incompletely defined 'low
> voltage range'. This will be ignored.
>   mmc0: error -110 whilst initialising SDIO card
> 
> This might explain what the problem is?
> 
> Anyway, thanks for your time, I will just wait a little longer as it
> almost works now,


First, where's debug log? There are plenty of debug messages in the MMC code -
just enable the debug printout and send it to me or Pierre.

Second, I'm not sure the problem is tifm specific, otherwise where's SDIO stuff
comes from?



      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ
