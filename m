Return-Path: <linux-kernel-owner+w=401wt.eu-S1757521AbXGDRNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521AbXGDRNM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 13:13:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753089AbXGDRM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 13:12:59 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:53606 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbXGDRM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 13:12:58 -0400
Date: Wed, 4 Jul 2007 18:12:38 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: andrzej zaborowski <balrogg@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: Don't miss the ARM-scsi fix.
Message-ID: <20070704171237.GC14170@flint.arm.linux.org.uk>
References: <200707031503.56561.rob@landley.net> <20070703122145.447c7d2c.akpm@linux-foundation.org> <20070703193104.GA27542@flint.arm.linux.org.uk> <fb249edb0707040500o42e945afr9040cbd268942555@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb249edb0707040500o42e945afr9040cbd268942555@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 04, 2007 at 02:00:58PM +0200, andrzej zaborowski wrote:
> It's just the case of being consistent with the already broken style
> in a function vs. correct style and inconsistency. I can never decide.

That's always a hard one to call, and the answer is generally to
follow the existing style, even if it's broken.  At a later date,
a patch which _just_ fixes the style can be submitted.

The point of _just_ fixing the style is that it's trivial to prove
that no other changes have happened - you build the file without
the change and save a copy of the object.  Apply the change and
rebuild, and compare the resulting text/data.  They should be the
same, if not there's a bug somewhere.

(There have been instances where reformatting the code has introduced
subtle unexpected changes, so it's always worth performing that check
just in case.)
