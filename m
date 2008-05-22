Return-Path: <linux-kernel-owner+w=401wt.eu-S932353AbYEVWTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353AbYEVWTf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 18:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760847AbYEVWTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 18:19:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49956 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760740AbYEVWTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 18:19:11 -0400
Date: Thu, 22 May 2008 15:18:34 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Natalie Protasevich <protasnb@gmail.com>,
       Bosko Radivojevic <bosko.radivojevic@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Number of bugs - statistics
Message-ID: <20080522151834.03f2790f@infradead.org>
In-Reply-To: <20080522165008.GB2727@cs181133002.pp.htv.fi>
References: <d6c8ef150805220528w6c4911bfq2be92eaa487a0f3@mail.gmail.com>
 <20080522144114.GC27301@cs181133002.pp.htv.fi>
 <20080522075135.4933161c@infradead.org>
 <20080522155425.GA2727@cs181133002.pp.htv.fi>
 <32209efe0805220920h1a2a0089t82b0173bbe239137@mail.gmail.com>
 <20080522165008.GB2727@cs181133002.pp.htv.fi>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2008 19:50:08 +0300
Adrian Bunk <bunk@kernel.org> wrote:

> > by various criteria: ALSA bugs
> > are numerous, which is not important for most enterprise server
> > users who would completely disregard this category, whereas desktop
> > users will probably concentrate on those more than any other.
> 
> The majority of machines running Linux most likely runs with ARM CPUs.

and on a 2.4 kernel, and with likely with some binary modules at that.
it's cool to brag about market share, but these boxes unfortunately
don't have any value for Linux development.

> 
> Show me any public source you want to use for getting serious data
> for this area.

You know, and I hate to say this, I'm getting a bit tired of your
attitude of just throwing up your arms at the problem and at the same
time trying to discredit anything and anybody who tries to improve the
situation. Really, it's not helping nor does it improve ANYTHING. 

I gave you real data before based on first hand experience from
maintainers. We now have crash data, and we have data from every place
in the kernel that dumps a backtrace. We track regressions and we can
show that we attack the majority of those very agressively, and Linus
has delayed releases for serious regressions. Just throwing your hands
in the air and saying "it's hard don't even try and I don't want you to
try" doesn't cut it.

Are we perfect? No. Can we do better? Absolutely. Should we try to do
better? YES PLEASE. Lets get constructive and try to make things better.

In the past, a few simple things improved the situation, such as
printk'ing the kernel version in the oops, as well as (longer back)
kksymoops. Or think of things like lockdep, or the pagealloc-debug
stuff. Going forward there are things we can do to improve things in the
kernel, even if you don't have hardware. We need to make the kernel
more selfdiagnosing. Detecting the problem, and if it's likely a
driver/hw interaction bug, sticking in a WARN_ON(). That's the sort of
thing even starting kernel developers can do to help improve the
quality even wihtout hardware access, because it helps us improve the
quality of bugreports, and it improves our ability to find patterns and
group duplicates into a top 10. 

Adrian, how about working on that sort of thing rather than keep saying
"impossible, we're doomed"... pretty please?

