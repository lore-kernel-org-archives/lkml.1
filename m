Return-Path: <linux-kernel-owner+w=401wt.eu-S1756237AbZLYQoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237AbZLYQoL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 11:44:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755693AbZLYQoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 11:44:10 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:45849 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755570AbZLYQoJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 11:44:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rw7VwIv0MI9SICjdf0LamNBzi8A1xgqQrR3WJe2OUO1rkAIBoubewRMBmmbRKQLw5q
         ZD7OIPpGMKCsvcI7lOYLPRD55JKn8s3gq7ewWwSxFuwkwJWj2L8c31hN6OLcwvjk1crT
         9uv/JVZr1aA1gCs6o422zt3IZZx5U9oOU/Gl8=
MIME-Version: 1.0
In-Reply-To: <s5hy6kr6nur.wl%tiwai@suse.de>
References: <alpine.LFD.2.00.0912250124410.11466@x200s>
	 <20091225122107.357d7102@mosly> <s5h637vmhcu.wl%tiwai@suse.de>
	 <20091225162528.5dbbbea0@mosly>
	 <8db1092f0912250731u46637a55lccb77e6cdb376a57@mail.gmail.com>
	 <s5hy6kr6nur.wl%tiwai@suse.de>
Date: Fri, 25 Dec 2009 17:44:06 +0100
Message-ID: <8db1092f0912250844p16d20209ib07f54f521bdb252@mail.gmail.com>
Subject: Re: intel hda regression: 2.6.33-rc{1,2}: hd-audio0 eats 25% CPU 
	(according to top)
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Sergei Trofimovich <slyich@gmail.com>, linux-kernel@vger.kernel.org,
       =?UTF-8?Q?=C3=89ric_Piel?= <eric.piel@tremplin-utc.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/12/25 Takashi Iwai <tiwai@suse.de>:

>
> OK, thanks for quick tests.
>
> It's a bit surprising that this resulted in the high CPU usage
> instead of erroneous behavior.  This should be rather a bug of
> codec chip...
>
> Anyway, Segei, which codec is on your machine?  Is it Analog Device
> one?
> IIRC, the one's on Maciej and Eric machines are AD codecs.
> If so, we can just revert the changes to patch_analog.c in that
> commit.
>

So all we have hp notebook and AD codecs? Maybe You are right, that is
bug in codec chip.

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
