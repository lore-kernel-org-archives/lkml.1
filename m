Return-Path: <linux-kernel-owner+w=401wt.eu-S1752638AbZKAOmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbZKAOmo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 09:42:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752385AbZKAOmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 09:42:42 -0500
Received: from www84.your-server.de ([213.133.104.84]:36344 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbZKAOmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 09:42:42 -0500
Subject: Re: [PATCH] proc: fix ->stack_start in compat mode
From: Stefani Seibold <stefani@seibold.net>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, m.s.tsirkin@gmail.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091101124301.GA16100@x200>
References: <20091028115602.GA26295@x200> <1257069245.3975.6.camel@wall-e>
	 <20091101124301.GA16100@x200>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sun, 01 Nov 2009 15:42:40 +0100
Message-ID: <1257086560.31587.7.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, den 01.11.2009, 15:43 +0300 schrieb Alexey Dobriyan:
> On Sun, Nov 01, 2009 at 10:54:05AM +0100, Stefani Seibold wrote:
> > Am Mittwoch, den 28.10.2009, 14:56 +0300 schrieb Alexey Dobriyan:
> > > Assign tsk->stack_start even when doing compat execve(2).
> > > 
> > > As side effect, fix segfault inside boehm-gc library.
> > > http://bugzilla.kernel.org/show_bug.cgi?id=14478
> > > 
> > > Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> > > ---
> > > 
> > >  Michael, please, confirm.
> > > 
> > >  Stefani, I get "Stack usage: 0 kB", you may want to look at it.
> > > 
> > 
> > Under which circumstance do you get 0 kb reported? What is your system
> > (mmu/nommu, 32bit/64bit, architecture and so on).
> 
> Well, no wonder it doesn't work:
> 
> 	#define KSTK_ESP(tsk)           -1 /* sorry. doesn't work for syscall. */
> 
> How does it supposed to work on live task?

Can you write it in a full sentence? Where did you located this define?


