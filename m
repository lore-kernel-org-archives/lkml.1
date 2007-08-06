Return-Path: <linux-kernel-owner+w=401wt.eu-S1764534AbXHFRFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764534AbXHFRFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 13:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756946AbXHFRFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 13:05:15 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38076 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757057AbXHFRFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 13:05:14 -0400
Date: Mon, 6 Aug 2007 18:05:10 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] take sched_debug.c out of nasal demon territory
Message-ID: <20070806170510.GY21089@ftp.linux.org.uk>
References: <20070806032659.GX21089@ftp.linux.org.uk> <Pine.LNX.4.64.0708061750270.13469@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708061750270.13469@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2007 at 05:51:29PM +0200, Jan Engelhardt wrote:
> 
> On Aug 6 2007 04:26, Al Viro wrote:
> >
> >	C99 6.10.3[11]: preprocessing directive within the argument list
> >of macro invocation => undefined behaviour.  Don't do that...
> 
> String concatenation ("a" "b") is not a preprocessing directive.

It is not, but #ifdef definitely is.
