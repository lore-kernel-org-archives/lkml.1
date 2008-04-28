Return-Path: <linux-kernel-owner+w=401wt.eu-S965382AbYD1Unf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965382AbYD1Unf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 16:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934761AbYD1UnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 16:43:23 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:25138 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934745AbYD1UnW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 16:43:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rHnuFqp03jWcvuuOXRCREhOKr2J21rY4ItMQh/LXSbfRfhbVqpk9F0SdIFAiZ1L15aWPbMZzezR53ZuWphBzZwXmYANzsogc9uimZuH7gaYu6BoDHAIvkyD0El90kIQiyw7QNMv74lSSljlQnnMUw+csSYQlD/87HHMghIxAVJA=
Message-ID: <c878e2290804281343x21b7d4aau479bea16c0f7a2c6@mail.gmail.com>
Date: Mon, 28 Apr 2008 22:43:21 +0200
From: "Kim Hansen" <kimhanse@gmail.com>
To: "Alex Dubov" <oakad@yahoo.com>
Subject: Re: tifm_7xx1: SD card is ignored
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <622387.91709.qm@web36701.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <c878e2290804270359w4fe4392flc41a5fb074152572@mail.gmail.com>
	 <622387.91709.qm@web36701.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2008 at 5:47 PM, Alex Dubov <oakad@yahoo.com> wrote:
>
>  --- Kim Hansen <kimhanse@gmail.com> wrote:
>
>  > I have the problem that the SD card slot does not work on my Toshiba
>  > Protege M400 with my current kernel (2.6.24), it worked for me with
>  > 2.6.18 but has been broken at least since 2.6.22.
>  >
>  > The problem is that nothing happens, dmesg is silent and I guess the
>  > cause is that the driver does not see the hardware.
>  >
>  > How should I start debugging this?
>  >
>
>  First, there's an option in the kernel config enabling debugging print-outs
>  (called "MMC Debugging" under MMC). Enable it, recompile the modules and you'll
>  get plenty of dmesg noise.

I just downloaded 2.6.25 and compiled, and now it works. The 2.6.24
kernel was from Debian, but I know that I also had the problem with
2.6.22 which I compiled myself. When 2.6.25 comes in Debian I will see
if the problem is still there.

>  Second, the fact modules are loaded means that driver sees the hardware all
>  right. There can be some sort of interplay between sdhci and tifm_sd as they
>  use the same chip. I think you should blacklist one of them. Which one -
>  depends on the settings in you flashmedia chip's eeprom (some vendors disable
>  sdhci interface and some flashmedia one).

Is there a way to find out which one to use ?

>  In the worst case, you can always blame the TI. Some TI guy notified me that my
>  driver contains errors affecting 803b series controllers (I myself have a
>  8033). He, however, had not told me what they are. Very nice, indeed.

Is there some tests I could run to see if I can find the errors?

Regards,
-- 
Kim Hansen
Vadgårdsvej 3, 2.tv
2860 Søborg
Fastnet: 3956 2437 -- Mobil: 3091 2437
