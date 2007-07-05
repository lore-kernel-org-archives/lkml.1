Return-Path: <linux-kernel-owner+w=401wt.eu-S1761517AbXGESHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761517AbXGESHw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 14:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759331AbXGESHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 14:07:44 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:32973 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759286AbXGESHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 14:07:43 -0400
Date: Thu, 5 Jul 2007 19:07:42 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sparse@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] bloody mess with __attribute__() syntax
Message-ID: <20070705180742.GP21478@ftp.linux.org.uk>
References: <20070705093528.GK21478@ftp.linux.org.uk> <alpine.LFD.0.98.0707050930330.9434@woody.linux-foundation.org> <20070705170918.GO21478@ftp.linux.org.uk> <alpine.LFD.0.98.0707051014380.9434@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0707051014380.9434@woody.linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2007 at 10:26:40AM -0700, Linus Torvalds wrote:
> And I'm just saying that:
>  (a) having two different magic keywords is silly and stupid, since:
>  (b) We already have *one* magic keyword that can (and has to) look at its 
>      subwords, and those sub-words have the capability to tell which of 
>      the two cases we have (by just using name-space lookups)

I.e. you get per-attribute rules (fsckloads of them) and no way to tell
what do the attributes apply to unless you know the rules for given attribute.

> See? THAT is what I'm saying. There's no reason to change existing syntax, 
> and in fact it is just _bad_ to change existing syntax, because it doesn't 
> actually buy us anything, because we already have the capability to parse 
> things in different contexts, and in fact allowing things to be parsed at 
> the same _time_ in the different contexts.

Oh, I understand what you are proposing (hell, I've mentioned that variant
in the first posting).  The trouble is not with being able to implement it.
I just don't like having no relationship between the syntax and operations
on types, that's all.  gcc variant, nasty as it is for our needs, at least
has that consistent.  IOW, you can get from declaration to type structure
without knowing what each attribute does.  Seeing that gcc rules are
weird enough to be confusing, at least having that weirdness clearly
indicated by __attribute__() instead of recalling which attribute is gcc-like
and which is not...
