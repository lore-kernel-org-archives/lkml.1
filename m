Return-Path: <linux-kernel-owner+w=401wt.eu-S933718AbXHFPvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933718AbXHFPvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 11:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932815AbXHFPvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 11:51:31 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:49193 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932798AbXHFPva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 11:51:30 -0400
Date: Mon, 6 Aug 2007 17:51:29 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Al Viro <viro@ftp.linux.org.uk>
cc: Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] take sched_debug.c out of nasal demon territory
In-Reply-To: <20070806032659.GX21089@ftp.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0708061750270.13469@fbirervta.pbzchgretzou.qr>
References: <20070806032659.GX21089@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 6 2007 04:26, Al Viro wrote:
>
>	C99 6.10.3[11]: preprocessing directive within the argument list
>of macro invocation => undefined behaviour.  Don't do that...

String concatenation ("a" "b") is not a preprocessing directive.

$ gcc -E test.c
# 1 "test.c"
# 1 "<built-in>"
# 1 "<command line>"
# 1 "test.c"
printf("a" "b");

(If it was, the "a" "b" would have already been joined.)


	Jan
-- 
