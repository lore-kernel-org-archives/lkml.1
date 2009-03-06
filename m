Return-Path: <linux-kernel-owner+w=401wt.eu-S1757444AbZCFWWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444AbZCFWWf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 17:22:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755040AbZCFWWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 17:22:25 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:41735
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973AbZCFWWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 17:22:25 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Jeff Dike <jdike@addtoit.com>
Subject: Re: [PATCH] Fix ARCH=um segfault on x86-64.
Date: Fri, 6 Mar 2009 16:22:21 -0600
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; x86_64; ; )
Cc: "Am??rico Wang" <xiyou.wangcong@gmail.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
References: <200903060042.19084.rob@landley.net> <20090306111834.GC8991@hack.private> <20090306143543.GA6983@c2.user-mode-linux.org>
In-Reply-To: <20090306143543.GA6983@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903061622.22289.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 March 2009 08:35:43 Jeff Dike wrote:
> On Fri, Mar 06, 2009 at 07:18:34PM +0800, Am??rico Wang wrote:
> > It does work well x86_64, but my question is that whether this will
> > break i386 or not, since before, CONFIG_3_LEVEL_PGTABLES depends on
> > EXPERIMENTAL on i386, this patch removes it.
>
> As long as CONFIG_3_LEVEL_PGTABLES is off on 32-bit, it should be fine.
>
> It did work, last I checked, but 3-level page tables on 32-bit is a
> very rarely used combination, and not useful.

I have no idea if my patch is the _right_ fix, I just know I couldn't use UML 
for 2 months and now I can.

If you enable CONFIG_EXPERIMENTAL, then it writes it out to the config file.  
If you don't, it hides it and doesn't write it out even though the value would 
be y.  (The visibility predicates affect the resulting data.)

Rob
