Return-Path: <linux-kernel-owner+w=401wt.eu-S967063AbXEGWD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967063AbXEGWD7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 18:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967056AbXEGWD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 18:03:57 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:3357 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967055AbXEGWD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 18:03:56 -0400
Date: Tue, 8 May 2007 00:03:56 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Sam Ravnborg <sam@ravnborg.org>
cc: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@stusta.de>
Subject: Re: kconfig: error out if recursive dependencies are found
In-Reply-To: <20070507193707.GA19985@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0705072203500.1479@scrub.home>
References: <20070502201741.GD9044@uranus.ravnborg.org>
 <20070506073615.GA6492@uranus.ravnborg.org> <20070506074038.GB6492@uranus.ravnborg.org>
 <Pine.LNX.4.64.0705070221500.1479@scrub.home> <20070507193707.GA19985@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 7 May 2007, Sam Ravnborg wrote:

> We need to point out _one_ of the faulty spots only.

The problem is you print only a random spot (which may not even be right 
one) of one of the involved symbols.
We could actually print out the whole faulty chain, but it would require a 
few changes, which might be useful to improve the select handling.

> But I see that kconfig records file:line for properties and menu entries
> but not for symbols.
> Any special reason why file:line is omitted for symbols (except size of allocated
> memory)?
> 
> Without looking into details it looks more relevant to have file:line for symbols
> rather than for prompts / properties..

A symbol can have multiple entries. The "config" line is just the start 
marker for the symbol information, which is the actual relevant part.

bye, Roman
