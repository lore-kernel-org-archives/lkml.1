Return-Path: <linux-kernel-owner+w=401wt.eu-S1761314AbYD2UFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761314AbYD2UFs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 16:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759217AbYD2UFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 16:05:19 -0400
Received: from 1wt.eu ([62.212.114.60]:3553 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756372AbYD2UFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 16:05:17 -0400
Date: Tue, 29 Apr 2008 22:05:05 +0200
From: Willy Tarreau <w@1wt.eu>
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [2.6 patch] UTF-8 fixes in comments
Message-ID: <20080429200505.GA15596@1wt.eu>
References: <20080428154023.GU2813@cs181133002.pp.htv.fi> <20080428230524.GK8474@1wt.eu> <48167A07.4000305@kernel.org> <20080429050605.GA27875@1wt.eu> <20080429072911.GA28059@cs181133002.pp.htv.fi> <20080429081423.GD30507@1wt.eu> <48177775.4000306@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <48177775.4000306@kernel.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 12:31:01PM -0700, H. Peter Anvin wrote:
> Willy Tarreau wrote:
> >
> >Well, I accidentally used a freshly installed laptop running mandriva 2008.
> >I was typing in a terminal inside KDE (I don't know the program name, sort
> >of an xterm, but with huge borders all around). I made a typo in a word and
> >typed in a "é" (e acute). Pressing backspace to fix it showed me that I
> >remove more chars than typed. I tried again. Pressing this letter 5 times,
> >then 10 times backspace. I removed 5 chars from the prompt. I suspect that
> >if I had used some chars with wider encoding (eg 4 bytes), I could have
> >removed as many... Clearly those tools are not ready.
> >
> 
> Presumably, this was konsole.

Possible. It was the one you get by clicking on a terminal icon.
Huuhhh what an horror, I'm discussing icons and GUIs on LKML. I must
take my meds :-)

> konsole works fine with UTF-8 (I use it 
> that way every day); the most common cause of this kind of problems is 
> people explicitly clobbering the locale or charset class defaults in 
> their login scripts.

I really doubt the miss would have done this. Or someone would have done
it for her which I really doubt in such a small time frame after a fresh
install from the day before. I will investigate though.

Willy

