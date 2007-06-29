Return-Path: <linux-kernel-owner+w=401wt.eu-S932765AbXF2CDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932765AbXF2CDa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 22:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765389AbXF2CDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 22:03:05 -0400
Received: from straum.hexapodia.org ([64.81.70.185]:18476 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765231AbXF2CDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 22:03:04 -0400
Date: Thu, 28 Jun 2007 19:03:02 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: Josh Triplett <josh@kernel.org>, Dave Young <hidave.darkstar@gmail.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Chris Shoemaker <c.shoemaker@cox.net>,
       Josh Triplett <josht@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Li Yang-r58472 <LeoLi@freescale.com>
Subject: Re: [PATCH] CodingStyle: Add information about trailing whitespace.
Message-ID: <20070629020302.GB16986@hexapodia.org>
References: <a8e1da0706280010m1e787bc2jae999084438982da@mail.gmail.com> <a8e1da0706280020ocf81ce7u98de87f16d674706@mail.gmail.com> <1182967160.8970.108.camel@josh-work.beaverton.ibm.com> <20070627180552.GA746@pe.Belkin> <Pine.LNX.4.64.0706280015320.11120@fbirervta.pbzchgretzou.qr> <a8e1da0706272300q3aee30der5349e85055f62a8e@mail.gmail.com> <46835047.8080600@kernel.org> <a8e1da0706272329j42997c3eh49a1b20df5892a0e@mail.gmail.com> <Pine.LNX.4.64.0706280850470.22579@fbirervta.pbzchgretzou.qr> <46835C16.9020700@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0706280020ocf81ce7u98de87f16d674706@mail.gmail.com> <46835C16.9020700@kernel.org>
User-Agent: Mutt/1.4.2.2i
X-PGP-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-PGP-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2007 at 11:58:30PM -0700, Josh Triplett wrote:
> Jan Engelhardt wrote:
> > On Jun 28 2007 06:29, dave young wrote:
> >> IMHO, another  cause of trailing whitespace is human error, for
> >> example long lines breaking will easy to cause the first line with one
> >> traling whitespace (original space between the last two words).
> > 
> > Most common errors (to me) are:
> > 
> >  - hit return+tab too quickly that it interchanges, hence producing
> >    the unwanted \t\n
> >  - hit return+return to start a new paragraph of code;
> >    the intermediate line remains indented if autoindent is on.
> 
> Interestingly, emacs gets that case right: when you hit enter it places the
> cursor at the properly indented insertion point, but if you leave the line
> without typing anything it does not leave the indentation.  I thought I
> remembered vim doing the same thing, but I just tested and it appears not.  It
> seems to avoid leaving subsequent lines indented, but not the first one.

I've previously found that vim's "cindent" mode is better than
"smartindent", which is better than "autoindent".  However, as of vim
6.3 autoindent seems to be fairly well off; the following does TRT:
`int SPC foo() RET { RET C-t int SPC x; RET RET foo(); RET'
(leaving an empty line between "int x;" and "foo();").  However, the
following does leave a line matching /^ +$/ even in smartindent and
cindent modes:
`int SPC foo() RET { RET int SPC x; RET SPC BS bar(); RET'
that is, if you edit the autoindented line before leaving it blank, then
vim 6.3 will not remove the autoindent spaces when you leave the line.

-andy
