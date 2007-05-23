Return-Path: <linux-kernel-owner+w=401wt.eu-S1765928AbXEWQfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765928AbXEWQfa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 12:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759703AbXEWQfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 12:35:11 -0400
Received: from gw.goop.org ([64.81.55.164]:49511 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760207AbXEWQfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 12:35:09 -0400
Message-ID: <46546D37.5030106@goop.org>
Date: Wed, 23 May 2007 17:35:03 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Bernd Petrovitsch <bernd@firmix.at>
CC: Nitin Gupta <nitingupta910@gmail.com>, Andrey Panin <pazke@donpac.ru>,
       linux-kernel@vger.kernel.org, Richard Purdie <richard@openedhand.com>
Subject: Re: [RFC] LZO1X de/compression support
References: <4cefeab80705180258g516a6f92w15a49e666dd62b66@mail.gmail.com>	 <20070518111107.GA27003@pazke.donpac.ru>	 <4cefeab80705220208w2200b2f1x1d7a8c7e0c01dfb9@mail.gmail.com> <1179869082.3649.6.camel@gimli.at.home>
In-Reply-To: <1179869082.3649.6.camel@gimli.at.home>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bernd Petrovitsch wrote:
> The "register" keyword is and was always from start *at most* a hint to
> the C compiler to use a register for that variable (similar to "inline"
> BTW).
> So every C compiler is allowed to simply ignore the "register" for any
> reason - be it "not implemented" or "the compiler knows better".
> Trivial reason: Think of a function with 100 register variables.
>   

The only useful semantic for "register" these days is that its illegal
to take the address of one.  So it might be useful if you want to make
sure you have no aliases of a particular variable.

    J
