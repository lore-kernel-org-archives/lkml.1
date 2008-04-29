Return-Path: <linux-kernel-owner+w=401wt.eu-S1757874AbYD2Tb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757874AbYD2Tb2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 15:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbYD2TbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 15:31:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41742 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbYD2TbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 15:31:18 -0400
Message-ID: <48177775.4000306@kernel.org>
Date: Tue, 29 Apr 2008 12:31:01 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [2.6 patch] UTF-8 fixes in comments
References: <20080428154023.GU2813@cs181133002.pp.htv.fi> <20080428230524.GK8474@1wt.eu> <48167A07.4000305@kernel.org> <20080429050605.GA27875@1wt.eu> <20080429072911.GA28059@cs181133002.pp.htv.fi> <20080429081423.GD30507@1wt.eu>
In-Reply-To: <20080429081423.GD30507@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
> 
> Well, I accidentally used a freshly installed laptop running mandriva 2008.
> I was typing in a terminal inside KDE (I don't know the program name, sort
> of an xterm, but with huge borders all around). I made a typo in a word and
> typed in a "é" (e acute). Pressing backspace to fix it showed me that I
> remove more chars than typed. I tried again. Pressing this letter 5 times,
> then 10 times backspace. I removed 5 chars from the prompt. I suspect that
> if I had used some chars with wider encoding (eg 4 bytes), I could have
> removed as many... Clearly those tools are not ready.
> 

Presumably, this was konsole.  konsole works fine with UTF-8 (I use it 
that way every day); the most common cause of this kind of problems is 
people explicitly clobbering the locale or charset class defaults in 
their login scripts.

	-hpa

