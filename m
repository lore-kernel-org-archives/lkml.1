Return-Path: <linux-kernel-owner+w=401wt.eu-S1752424AbXBHSnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424AbXBHSnx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 13:43:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbXBHSnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 13:43:53 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:52446 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424AbXBHSnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 13:43:52 -0500
Date: Thu, 8 Feb 2007 19:42:07 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: somebody dropped a (warning) bomb
In-Reply-To: <Pine.LNX.4.64.0702080819350.8424@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.61.0702081851310.1364@yvahk01.tjqt.qr>
References: <45CB3B28.60102@garzik.org> <Pine.LNX.4.64.0702080819350.8424@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 8 2007 08:33, Linus Torvalds wrote:
>
>And the thing is, sometimes -Wpointer-sign-compare is just horribly 
>broken. For example, you cannot write a "strlen()" that doesn't 
>complain about "unsigned char *" vs "char *". And that is just a BUG.
>
>I'm continually amazed at how totally clueless some gcc warnings are. 
>You'd think that the people writing them are competent. And then 
>sometimes they show just how totally incompetent they are, by making it 
>impossible to use "unsigned char" arrays together with standard 
>functions.

I generally have to agree with you about the unsigned char* vs char*. It 
is a problem of the C language that char can be signed and unsigned, and 
that people, as a result, have used it for storing 
"shorter_than_short_t"s.

What C needs is a distinction between char and int8_t, rendering "char" 
an unsigned at all times basically and making "unsigned char" and 
"signed char" illegal types in turn.


Jan
-- 
ft: http://freshmeat.net/p/chaostables/
