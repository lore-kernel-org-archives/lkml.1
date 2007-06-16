Return-Path: <linux-kernel-owner+w=401wt.eu-S1756135AbXFPMHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135AbXFPMHU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 08:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754206AbXFPMHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 08:07:08 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:3351 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070AbXFPMHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 08:07:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=RWbxdt1h+c/+JhymiYo0j39sdzcPJNUWktX054uXBlGDf8v/DIJejod7thSsBVVr3r65iqD06egFTZZ+7UfqIH4pvbkMEQecQ3Z4v9UVd4zPBiZFfipt+IVr3Lpv8zDUU4VdAyOzDKwASKmU+qpI7BHFGAi65EKD/SS+6tlooUA=
Message-ID: <4673D264.8090306@gmail.com>
Date: Sat, 16 Jun 2007 14:07:00 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Thierry Merle <thierry.merle@free.fr>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] V4L: stk11xx, add a new webcam driver
References: <2172422218943432279@wsc.cz>	 <1180364420.21547.160.camel@localhost>	 <d9def9db0705280814h8fbd0b7qaf8b324ff20e83d6@mail.gmail.com>	 <1180378677.21547.189.camel@localhost>	 <d9def9db0705281217t514462e1wef412de7a9c81826@mail.gmail.com>	 <1180383071.21547.230.camel@localhost> <465B49EB.4080204@free.fr>	 <465BBAFB.30906@free.fr> <1180448712.21547.314.camel@localhost>	 <465C7920.2080203@free.fr> <1180467116.9509.73.camel@localhost>	 <465F3361.106@free.fr> <1180739401.3904.50.camel@localhost>	 <466131CB.20301@free.fr> <466131CB.20301@free.fr>	 <6872422218943432279_1@wsc.cz> <1181994378.22144.11.camel@localhost>
In-Reply-To: <1181994378.22144.11.camel@localhost>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thierry Merle napsal(a):
> Le vendredi 15 juin 2007 à 23:08 +0200, Jiri Slaby a écrit :
>> Mauro Carvalho Chehab wrote:
>>> Em SÃ¡b, 2007-06-02 Ã s 11:00 +0200, Thierry Merle escreveu:
>>>> Nevertheless, I will start to specify the framework.
>>>> The helper daemon would link to the v4l2-apps/lib.
>>> Ok, thanks!
>> Ok, here comes updated version of stk11xx driver. Note that it's not
>> still
>> separated into more files (I'll do this as the last step) and also
>> resize
>> and bayer->rgb conversion remains. This is what I'm interested in --
>> is
>> there some embryo of library with resize and conversion? Or what was
>> the
>> decision to create?
> 
> Hi Jiri,
> sorry I started the specification but nothing finalized (and
> consequently no code).
> Here is the start of my idea for a v4l2_extension:
> http://thierry.merle.free.fr/v4l2_extension/general.html
> My new USB tuner took me all my little time and I did not get into
> details (the spec is incomplete).
> Well, as you insist I will explain a bit more :)
> Please comment, tell me what you don't understand I will try to update
> during this week-end...

At the first look seems good, the SD is self-explaining. If you want me to help
you with something, feel free to drop a message ;).

In the meantime until some early increment would be developped, is it
feasible/acceptable to merge the driver as is (after changing some things which
will be eventually commented plus splitting into several files)?

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
