Return-Path: <linux-kernel-owner+w=401wt.eu-S1754776AbYFGEbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbYFGEbQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 00:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbYFGEbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 00:31:00 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:58662
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbYFGEa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 00:30:59 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Tim Bird <tim.bird@am.sony.com>
Subject: Re: [PATCH] console - Add configurable support for console charset translation
Date: Fri, 6 Jun 2008 23:29:53 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Adrian Bunk <adrian.bunk@movial.fi>, linux-tiny <Linux-tiny@selenic.com>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
References: <48447615.5050806@am.sony.com> <20080604194002.GF4189@cs181133002.pp.htv.fi> <4849CCA3.7040102@am.sony.com>
In-Reply-To: <4849CCA3.7040102@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806062329.54019.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 June 2008 18:47:47 Tim Bird wrote:
> At a minimum, it would be nice to have a few nice examples
> of really, really small configs for things like qemus for different
> architectures (just to give embedded developers who are working
> on size a starting point).

That's more or less what I'm trying to do with my Firmware Linux project: 
creating cross compilers and minimal native build environments for every qemu 
target.

http://landley.net/code/firmware
http://landley.net/hg/firmware

I currently have variants of arm, powerpc, mips, x86, and x86-64 working, and 
several others (sh4, sparc, m68k) in various stages of development.  (I think 
sparc just needs one minor bug fixed, I just can't bring myself to _care_ 
about sparc.  m68k is hitting an internal compiler error in gcc.  sh4 isn't 
properly supported by qemu yet: no boards with a hard drive.)

I just did a new release, which finally has the distcc trick implemented.  
(Not _quite_ useful yet because the build environment is missing seven 
important commands I hope to add next release.)

Feel free to ask me any questions about it...

Rob

P.S.  The mips kernel config recently changed because the qemu mips platform 
went away in 2.6.25, and the new one is malta_defconfig with some of the 
obvious options removed.  I'm working on a more stripped-down one as we 
speak, but I didn't hold up the release for it...
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
