Return-Path: <linux-kernel-owner+w=401wt.eu-S1760944AbXF2JUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760944AbXF2JUQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 05:20:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754507AbXF2JUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 05:20:03 -0400
Received: from mail.gmx.net ([213.165.64.20]:44742 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754506AbXF2JUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 05:20:00 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX18BRk5E6pgBfs7ZFQpLzDHX7ePOfcVnXhftcMRyye
	z8NMeyvCGWD0a6
Date: Fri, 29 Jun 2007 11:21:21 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Josh Triplett <josh@kernel.org>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Dave Young <hidave.darkstar@gmail.com>,
       Li Yang-r58472 <LeoLi@freescale.com>,
       Chris Shoemaker <c.shoemaker@cox.net>,
       Josh Triplett <josht@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [OT] Vim highlighting for trailing spaces
Message-ID: <20070629092121.GA6487@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Josh Triplett <josh@kernel.org>,
	Jan Engelhardt <jengelh@computergmbh.de>,
	Kyle Moffett <mrmacman_g4@mac.com>,
	Dave Young <hidave.darkstar@gmail.com>,
	Li Yang-r58472 <LeoLi@freescale.com>,
	Chris Shoemaker <c.shoemaker@cox.net>,
	Josh Triplett <josht@linux.vnet.ibm.com>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <46835C16.9020700@kernel.org> <989B956029373F45A0B8AF0297081890D834BE@zch01exm26.fsl.freescale.net> <a8e1da0706280010m1e787bc2jae999084438982da@mail.gmail.com> <a8e1da0706280020ocf81ce7u98de87f16d674706@mail.gmail.com> <7958FF64-140B-435A-8B69-A503C5C18D79@mac.com> <Pine.LNX.4.64.0706290938460.22579@fbirervta.pbzchgretzou.qr> <4684BA77.7090804@kernel.org> <Pine.LNX.4.64.0706291001320.22579@fbirervta.pbzchgretzou.qr> <4684C5EE.9000606@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4684C5EE.9000606@kernel.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.06.29 01:42:22 -0700, Josh Triplett wrote:
> Jan Engelhardt wrote:
> > On Jun 29 2007 00:53, Josh Triplett wrote:
> >> And if you really want highlighting, you can always use grep --color. :)
> > 
> > Been there, done that, have GREP_COLOR env variable defined!
> 
> Same here.  Now I just need to convince git-grep to use it.

You need to convince grep. When piping its output to less, it won't
colorize unless forced. Always forcing color via GREP_OPTIONS might
break certain use-cases, and git-grep doesn't allow to pass options. So
for me, a bash alias it is:

alias gg='GREP_OPTIONS=--color=always git-grep'

You might need to set LESS=-R in addition to that, to stop less from
stripping the color codes.

Björn
