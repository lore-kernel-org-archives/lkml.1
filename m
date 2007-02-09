Return-Path: <linux-kernel-owner+w=401wt.eu-S1945955AbXBIBWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945955AbXBIBWH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 20:22:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945995AbXBIBWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 20:22:07 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:35359 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945955AbXBIBWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 20:22:05 -0500
Date: Fri, 9 Feb 2007 02:21:59 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Andreas Schwab <schwab@suse.de>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Oleg Verych <olecom@flower.upol.cz>
Subject: Re: The who needs reviews anyways [PATCH]
In-Reply-To: <jey7n8urcg.fsf@sykes.suse.de>
Message-ID: <Pine.LNX.4.64.0702090214460.14457@scrub.home>
References: <Pine.LNX.4.64.0702082227020.14457@scrub.home> <jey7n8urcg.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 9 Feb 2007, Andreas Schwab wrote:

> Roman Zippel <zippel@linux-m68k.org> writes:
> 
> > - printf has other side effects, instead stop pretending we support 
> >   something else than bash
> 
> printf is a much better echo, but you need to use it properly as well.
> Either use %s to print a literal string or %b to let it interpret escape
> sequences.

Hmm, I didn't know about %b, which would indeed be another possibility 
here, although I think it would only make a real difference if we decided 
to make (and more importantly keep) all our scripts POSIX clean.

bye, Roman
