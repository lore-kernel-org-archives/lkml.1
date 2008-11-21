Return-Path: <linux-kernel-owner+w=401wt.eu-S1757314AbYKUXeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314AbYKUXeL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 18:34:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881AbYKUXd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 18:33:56 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:44142 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818AbYKUXdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 18:33:55 -0500
Date: Fri, 21 Nov 2008 18:33:52 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       peterz@infradead.org, tytso@mit.edu, arjan@infradead.org,
       srostedt@redhat.com
Subject: Re: [PATCH 4/4] trace: profile all if conditionals
In-Reply-To: <20081121152030.7024971e.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0811211832460.7797@gandalf.stny.rr.com>
References: <20081121071213.365288293@goodmis.org> <20081121071328.462456268@goodmis.org> <20081121152030.7024971e.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 21 Nov 2008, Andrew Morton wrote:
> >
> > +#define if(cond) if (__builtin_constant_p((cond)) ? !!(cond) :		\
> 
> wheee...
> 
> Now how are you going to profile ?:, while, for(;expr;), etc? ;)

I don't know. Give me a few months, I'll figure out a way ;-)

This is just a way to see if we should add or remove more if annotations.

 (i.e. likely() and unlikey() )

-- Steve

