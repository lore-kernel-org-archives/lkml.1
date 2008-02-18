Return-Path: <linux-kernel-owner+w=401wt.eu-S1755358AbYBRRdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358AbYBRRdX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 12:33:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751543AbYBRRdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 12:33:15 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:50012 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbYBRRdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 12:33:14 -0500
Date: Mon, 18 Feb 2008 09:32:15 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andi Kleen <andi@firstfloor.org>, Frans Pop <elendil@planet.nl>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Unable to continue testing of 2.6.25
Message-ID: <20080218093215.5cf611a8@laptopd505.fenrus.org>
In-Reply-To: <20080218171159.GA24090@basil.nowhere.org>
References: <200802171025.30590.elendil@planet.nl>
	<20080217124650.576990ce@laptopd505.fenrus.org>
	<p73mypyxx6z.fsf@bingen.suse.de>
	<20080218085018.05f3190a@laptopd505.fenrus.org>
	<20080218171159.GA24090@basil.nowhere.org>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Feb 2008 18:11:59 +0100
Andi Kleen <andi@firstfloor.org> wrote:
> > to do is go via an intermediate UC state and the really expensive
> > process from the manual is not needed.
> 
> Ok then you're proposing to use a even more expensive operation just
> to patch this over. I guess that will work as long as we assume
> none of the callers cares too much about performance, 

I've yet to see a user who wants WC. Lets face it, WC *sucks*. This is why
the folks who care about performance (the graphics guys) stopped using it.
WC is slow, and on modern cpus leads to really bad performance. I'm really
half tempted to just ignore WC entirely and suggest that we don't even implement
it in the kernel. Yes it's really that bad.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
