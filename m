Return-Path: <linux-kernel-owner+w=401wt.eu-S1762141AbYEXU6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762141AbYEXU6W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 16:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758395AbYEXU6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 16:58:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52652 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758140AbYEXU6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 16:58:15 -0400
Message-ID: <48388097.3060707@zytor.com>
Date: Sat, 24 May 2008 13:54:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Tom Spink <tspink@gmail.com>, Vegard Nossum <vegard.nossum@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, Steve French <smfrench@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: kernel coding style for if ... else which cross #ifdef
References: <524f69650805231211r315be4e4u5890aa0f914bcb4f@mail.gmail.com>	 <4837AAE2.9090102@zytor.com>	 <20080524064201.GA4133@uranus.ravnborg.org>	 <4837E89D.9040008@goop.org>	 <20080524112704.GA7292@uranus.ravnborg.org>	 <483827CE.9080200@goop.org>	 <20080524153611.GA13890@uranus.ravnborg.org>	 <48383830.6060504@goop.org>	 <19f34abd0805240857l57e667fdicb240baf898f6296@mail.gmail.com>	 <48383C26.5040106@goop.org> <7b9198260805240940v46db928ak9bcacf9363c46d41@mail.gmail.com> <48387CCB.1030801@goop.org> <48387DF0.7000600@zytor.com> <48387FE7.2080608@goop.org>
In-Reply-To: <48387FE7.2080608@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
>>
>> In particular, the use of #ifdef is crap to begin with.  Using #if 
>> even for the preprocessor makes it possible to trap misspellings. 
> 
> Yes, I'd agree if we were starting from scratch.  But given that we 
> can't get rid of CONFIG_* and their dubious semantics, we just have to 
> make do.
> 

That's a very defeatist stance, and quite frankly bogus.

Doing it as a flag day event is not really practical, which is why we 
need a new set of symbols.  However, at that point we can discourage 
continuing use of the CONFIG_ symbols and deprecate them over time. 
It's not like we're talking about user-space-visible interfaces here!

	-hpa
