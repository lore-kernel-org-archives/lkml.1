Return-Path: <linux-kernel-owner+w=401wt.eu-S1756826AbYFJSUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826AbYFJSUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 14:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752754AbYFJSUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 14:20:31 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:57435 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbYFJSUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 14:20:30 -0400
X-BigFish: VPS-23(z1fc9iz1432R98dR1805Mzz10d3izzz2fh6bh62h)
X-Spam-TCS-SCL: 1:0
Message-ID: <484EC576.5080302@am.sony.com>
Date: Tue, 10 Jun 2008 11:18:30 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Rob Landley <rob@landley.net>, linux-tiny <Linux-tiny@selenic.com>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: mainlining min-configs...
References: <48447615.5050806@am.sony.com> <20080604194002.GF4189@cs181133002.pp.htv.fi> <4849CCA3.7040102@am.sony.com> <200806062329.54019.rob@landley.net> <484DDAD9.2000306@am.sony.com> <20080610083610.GC1987@cs181133002.pp.htv.fi>
In-Reply-To: <20080610083610.GC1987@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Jun 2008 18:20:17.0216 (UTC) FILETIME=[A24C3C00:01C8CB26]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> But if you want to discover size change with minimal configs early you 
> anyway have to both:
> - constantly keep your configs in shape so that they are both minimal
>   for some set of hardware support and features and
> - investigate for any size changes what caused them
>   (experience has shown that putting information on a webpage doesn't
>    fix problems - even for compile errors).
Amen to that last point!

> 
> You need both, and ideally constantly done by the same person against 
> Linus' tree, -next and -mm.
> 
> Where to get your minimal configs from at the start is just a small 
> thing at the beginning - don't underestimate the required manual work 
> that will have to be done each week.

This is probably why I haven't signed up for this myself previously.
I'd be interested in finding out the rate at which defconfigs
bitrot in mainline.  My experience is that usually a 'make oldconfig'
will produce something usable.  But maybe that wouldn't be as
effective with a minconfig?

Maybe I'll collect some minconfigs, and try maintaining them
in my own tree for a few releases to see how onerous it is...
The problem is that I can only reasonably do this for boards
I have, so there'd only be a few.  But maybe that'd be enough.
They would really only be meant as examples.
 -- Tim


=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

