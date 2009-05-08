Return-Path: <linux-kernel-owner+w=401wt.eu-S1754435AbZEHHML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435AbZEHHML (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 03:12:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbZEHHL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 03:11:56 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:33772 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152AbZEHHLz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 03:11:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=V1n5Pvy8Mf6T5qkXaU5gSIUV3jeFg1PDCsoBNLDEWHND3ER+7HuDPZGWfsYsJa659y
         /7+wN59pVD4YehRDZcN+ucE1oRoBFE1hE1ECllxgx4wDGc9W2eATqxHCxVEb9+7GUshl
         dlIq20V9NjsOfSouwSLs4tMT+8Xo0EGXJp5F0=
MIME-Version: 1.0
In-Reply-To: <20090507214645.GB14611@elf.ucw.cz>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net>
	 <200905071945.45928.rjw@sisk.pl>
	 <f22f52180905071052o68e3999co8e353d46aa60b47c@mail.gmail.com>
	 <200905072022.15202.rjw@sisk.pl>
	 <b637ec0b0905071157x2d6f050aqcb825241c51ccb84@mail.gmail.com>
	 <20090507214645.GB14611@elf.ucw.cz>
Date: Fri, 8 May 2009 09:11:55 +0200
Message-ID: <b637ec0b0905080011g4594917ai786ffe293f9b9a32@mail.gmail.com>
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
From: Fabio Comolli <fabio.comolli@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matt Price <moptop99@gmail.com>,
       linux-kernel@vger.kernel.org, Nigel Cunningham <nigel@tuxonice.net>,
       linux-pm@lists.linux-foundation.org, tuxonice-devel@lists.tuxonice.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 7, 2009 at 11:46 PM, Pavel Machek <pavel@ucw.cz> wrote:
> On Thu 2009-05-07 20:57:44, Fabio Comolli wrote:
...
>>
>> Well, if I may jump in I suggest you start with the full-memory image
>> functionality. This is in my opinion the biggest advantage in tuxonice
>> vs. uswsusp.
>
> Neither tuxonice nor swsusp can write full-memory image (it is mostly
> impossible to do in unlikely case of all memory is consumed by
> kmalloc). Now, tuxonice can produce bigger images than swsusp...
>

Pavel, please. (u)swsusp can save images up to half the physical
memory IIRC; with toi I used to easily save 980MB of image on a 1GB
laptop. You can't honestly compare the two things.

> Rafael had short patch for similar efect some time ago, but we could
> not find anyone to really review it...
>                                                                Pavel
> --

Regards,
Fabio




> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>
