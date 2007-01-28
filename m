Return-Path: <linux-kernel-owner+w=401wt.eu-S932443AbXA1Hy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443AbXA1Hy0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 02:54:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932436AbXA1Hy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 02:54:26 -0500
Received: from terminus.zytor.com ([192.83.249.54]:40835 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932443AbXA1HyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 02:54:25 -0500
Message-ID: <45BC56A0.1000906@zytor.com>
Date: Sat, 27 Jan 2007 23:54:08 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: linux-kernel@vger.kernel.org, thomas@tungstengraphics.com
Subject: Re: Support for i386 PATs
References: <200701271059.l0RAxxP5018994@harpo.it.uu.se>
In-Reply-To: <200701271059.l0RAxxP5018994@harpo.it.uu.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson wrote:
> 
> 3) Many Intel processors, including at least most P6s and probably
> also some P4s, have an erratum which effectively halves the number
> of available PAT entries, forcing an OS to make the low 4 and upper
> 4 PAT entries identical.
> 
> I don't know if 4 PAT types suffice for the kinds of uses people
> have in mind. But support for PAT would either have to restrict
> itself to only 4 PAT types, or ensure that it is only enabled on
> new enough processors where it actually works.
> 
> You will need to read all available Intel errata sheets (spec updates)
> to determine which processors are affected and which are OK.
> 

There aren't really that many useful caching types, so it probably 
doesn't matter all that much.

The types that matters most are WB, WC, and UC.  The fourth one could be 
WT, or it could be UC- (however, UC- can *always* be emulated by simply 
having the kernel being aware of the MTRR settings.)

	-hpa

