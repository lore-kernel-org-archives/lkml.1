Return-Path: <linux-kernel-owner+w=401wt.eu-S1754754AbYDIN6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbYDIN6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 09:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbYDIN61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 09:58:27 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2615 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbYDIN61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 09:58:27 -0400
Date: Wed, 9 Apr 2008 14:58:40 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] checkpatch: relax spacing and line length
Message-ID: <20080409135840.GO17915@shadowen.org>
References: <alpine.LNX.1.10.0804060653020.30794@fbirervta.pbzchgretzou.qr> <20080408171257.GF17915@shadowen.org> <87ej9gp6ol.fsf@basil.nowhere.org> <20080409081943.GI17915@shadowen.org> <20080409083013.GJ17915@shadowen.org> <20080409084606.GD19010@one.firstfloor.org> <20080409131420.GL17915@shadowen.org> <alpine.LNX.1.10.0804091517260.4411@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0804091517260.4411@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2008 at 03:18:47PM +0200, Jan Engelhardt wrote:
> 
> On Wednesday 2008-04-09 15:14, Andy Whitcroft wrote:
> >On Wed, Apr 09, 2008 at 10:46:06AM +0200, Andi Kleen wrote:
> >> > Oh, and if people felt that the concensus was for something to be
> >> > implemented and that you are waiting for me to implement the change in
> >> > checkpatch; please say so.
> >> 
> >> Well at least I think the printk change is a good one to implement and there 
> >> wasn't much protest to it at least.
> >
> >Ok.  will put this on my todo list.
> 
> Instead of
> 
> 	if (foo) {
> 		if (baz) {
> 			++x;
> printk("Oh so long line makes my coding style go wary... nonsensical sentence\n");
> 		}
> 	}
> 
> I'd keep the indent and allow elongated lines:
> 
> 	if (foo) {
> 		if (baz) {
> 			++x;
> 			printk("Oh so long line makes my coding style go wary... nonsensical sentence\n");
> 		}
> 	}
> 
> Or perhaps you just pointed out we need a smarter grep program! :)


My preference would be for the latter.  Keep the line indent consistent
and allow the line to overspill.  But that would depend on the concensus
obviously.  The originally suggested layout was:

			printk(
"Oh ....",
				a, b);

-apw
