Return-Path: <linux-kernel-owner+w=401wt.eu-S1755471AbYFKFvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471AbYFKFvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 01:51:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbYFKFvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 01:51:45 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:50189
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbYFKFvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 01:51:45 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Tim Bird <tim.bird@am.sony.com>
Subject: Re: mainlining min-configs...
Date: Wed, 11 Jun 2008 00:51:34 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Adrian Bunk <bunk@kernel.org>, linux-tiny <Linux-tiny@selenic.com>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
References: <48447615.5050806@am.sony.com> <20080610083610.GC1987@cs181133002.pp.htv.fi> <484EC576.5080302@am.sony.com>
In-Reply-To: <484EC576.5080302@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806110051.34919.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 June 2008 13:18:30 Tim Bird wrote:
> bitrot in mainline.  My experience is that usually a 'make oldconfig'
> will produce something usable.  But maybe that wouldn't be as
> effective with a minconfig?

I'm probably going to have to start breaking down and patching the kconfig 
infrastructure.  (Today, I drove allnoconfig into an endless loop.  Go me.)

So far the only "gotcha" I've found is added guard symbols, and it's 
semantically pretty clear what a miniconfig should do there: force open the 
menu that contains a symbol you're setting, rather than _ignore_ that symbol.

> Maybe I'll collect some minconfigs, and try maintaining them
> in my own tree for a few releases to see how onerous it is...

The thing about my .configs is that I boot test them each new kernel release, 
using qemu.  This is 100% scriptable, actually, which you can seldom say 
about real hardware.

> The problem is that I can only reasonably do this for boards
> I have, so there'd only be a few.  But maybe that'd be enough.
> They would really only be meant as examples.

Start with qemu and work your way out?  That's what I'm doing.  (Any platform 
that isn't emulated by qemu is almost by definition not very interesting...)

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
