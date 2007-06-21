Return-Path: <linux-kernel-owner+w=401wt.eu-S1757754AbXFUAZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757754AbXFUAZI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 20:25:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753492AbXFUAY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 20:24:58 -0400
Received: from twin.jikos.cz ([213.151.79.26]:34025 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315AbXFUAY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 20:24:57 -0400
Date: Thu, 21 Jun 2007 02:24:50 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Pavel Machek <pavel@ucw.cz>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] blink: Only blink when parameter is set
In-Reply-To: <20070621002034.GA18143@elf.ucw.cz>
Message-ID: <Pine.LNX.4.64.0706210222390.3068@twin.jikos.cz>
References: <20070617083904.GC4496@suse.de> <20070620201637.GA5610@ucw.cz>
 <Pine.LNX.4.64.0706210147260.3068@twin.jikos.cz> <20070621002034.GA18143@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2007, Pavel Machek wrote:

> > this has probably been already solved by proper throttling - see 
> > http://lkml.org/lkml/2007/6/15/22
> No, it was not. I still saw the problems with CONFIG_BLINK on, that is
> one blink per 5 seconds or something.
> We should rename CONFIG_BLINK to
> CONFIG_BREAK_THINKPAD_KEYBOARD_AND_MORE.

In fact it looks quite weird that one blink per 5 seconds can break the 
keyboard, in fact.

Seems like Dmitry is missing in CC, added.

Thanks,

-- 
Jiri Kosina
