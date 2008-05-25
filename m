Return-Path: <linux-kernel-owner+w=401wt.eu-S1753176AbYEZAAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbYEZAAb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 20:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751415AbYEZAAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 20:00:22 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:46100 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404AbYEZAAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 20:00:21 -0400
Date: Mon, 26 May 2008 02:57:43 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Tom Spink <tspink@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, Steve French <smfrench@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: kernel coding style for if ... else which cross #ifdef
Message-ID: <20080525235743.GO1791@cs181133002.pp.htv.fi>
References: <20080524153611.GA13890@uranus.ravnborg.org> <48383830.6060504@goop.org> <19f34abd0805240857l57e667fdicb240baf898f6296@mail.gmail.com> <48383C26.5040106@goop.org> <7b9198260805240940v46db928ak9bcacf9363c46d41@mail.gmail.com> <48387CCB.1030801@goop.org> <48387DF0.7000600@zytor.com> <48387FE7.2080608@goop.org> <48388097.3060707@zytor.com> <4838855F.2090701@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4838855F.2090701@goop.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2008 at 10:15:11PM +0100, Jeremy Fitzhardinge wrote:
> H. Peter Anvin wrote:
>> That's a very defeatist stance, and quite frankly bogus.
>
> But <stamp foot> coding is *hard*.
>
>> Doing it as a flag day event is not really practical, which is why we  
>> need a new set of symbols.  However, at that point we can discourage  
>> continuing use of the CONFIG_ symbols and deprecate them over time.  
>> It's not like we're talking about user-space-visible interfaces here!
>
> Well, I'm thinking more along the lines of:
>
>   1. We introduce this <whatever> mechanism
>   2. Hundreds of people pop out of the woodwork thinking "this looks
>      more fun than tweaking whitespace"
>   3. They produce one-hundred trillion "convert #ifdef to if()" patches
>   4. We have one-hundred trillion^2 followup "fix build with this
>      .config" patches
>
> 3 might be enough to finally drive Andrew out of the kernel business,  
> but 4 definitely would be.
>
> The whole point is to try and get config-invariant build breakages, so  
> that we become less dependent on lots of randconfig testing.
>...

We do not have any serious problems where we actually depend on 
randconfig.

randconfig is nice, but even if it would suddenly become no longer 
available we wouldn't have significantely more build breakages in 
stable kernels (perhaps a few more in the pathological cornercases
only randconfig hits).

If this was really "the whole point" it wasn't not worth it.

Real value would come from getting errors for mistyped kconfig variable 
names.

>    J

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

