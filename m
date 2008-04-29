Return-Path: <linux-kernel-owner+w=401wt.eu-S1755124AbYD2FG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124AbYD2FG1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 01:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbYD2FGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 01:06:18 -0400
Received: from 1wt.eu ([62.212.114.60]:3490 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154AbYD2FGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 01:06:18 -0400
Date: Tue, 29 Apr 2008 07:06:05 +0200
From: Willy Tarreau <w@1wt.eu>
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [2.6 patch] UTF-8 fixes in comments
Message-ID: <20080429050605.GA27875@1wt.eu>
References: <20080428154023.GU2813@cs181133002.pp.htv.fi> <20080428230524.GK8474@1wt.eu> <48167A07.4000305@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48167A07.4000305@kernel.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 06:29:43PM -0700, H. Peter Anvin wrote:
> Willy Tarreau wrote:
> >Is this really needed Adrian ? I mean, everyone reads iso-8859-1, not
> >everyone reads UTF-8.
> 
> "Everyone" who speaks a Western European language, perhaps; and even 
> then, mostly because a lot of tools still have a "oh, it's not valid 
> UTF-8, guess iso-8859-1" mode.

Or simply because people have not migrated all their install, or have
explicitly disabled UTF-8 a few hours after starting to use it once
they discovered the mess it caused and the poor support from the
tools :-/

> The most common instance of non-ASCII 
> characters in Linux kernel code are people's names, and there are plenty 
> of names which aren't representable in either ASCII or iso-8859-1.
> 
> The debate on this was years ago, and the consensus was to migrate to 
> UTF-8; however, the salient information should be expressed in the ASCII 
> character set unless impossible.

And do we really consider that people's names in *comments* cannot
be converted to pure ASCII ? I'm western european and have always
been against accents in comments (another reason to write comments
in english BTW). Unix and internet have lived without accents for
almost 30 years without anyone really bothering. And now we try to
put them everywhere (even in domain names, implying big security
issues) and it causes real annoyances. People's names have not
changed in 30 years, so I guess that the rules used during this
time to ASCII-fy the names are still usable.

> 	-hpa

Willy

