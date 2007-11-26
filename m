Return-Path: <linux-kernel-owner+w=401wt.eu-S1753509AbXKZGQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbXKZGQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 01:16:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbXKZGP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 01:15:59 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:18353 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbXKZGP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 01:15:58 -0500
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, sam@ravnborg.org
Subject: Re: [PATCH RFC] [1/9] Core module symbol namespaces code and intro.
X-Message-Flag: Warning: May contain useful information
References: <20071122343.446909000@suse.de> <adatznarrzc.fsf@cisco.com>
	<200711261228.15155.rusty@rustcorp.com.au>
From: Roland Dreier <rdreier@cisco.com>
Date: Sun, 25 Nov 2007 22:15:44 -0800
In-Reply-To: <200711261228.15155.rusty@rustcorp.com.au> (Rusty Russell's message of "Mon, 26 Nov 2007 12:28:14 +1100")
Message-ID: <adahcj9sfan.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 26 Nov 2007 06:15:44.0833 (UTC) FILETIME=[C75C4310:01C82FF3]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Except C doesn't have namespaces and this mechanism doesn't create them.  So 
 > this is just complete and utter makework; as I said before, noone's going to 
 > confuse all those udp_* functions if they're not in the udp namespace.

I don't understand why you're so opposed to organizing the kernel's
exported symbols in a more self-documenting way.  It seems pretty
clear to me that having a mechanism that requires modules to make
explicit which (semi-)internal APIs makes reviewing easier, makes it
easier to communicate "please don't use that API" to module authors,
and takes at least a small step towards bringing the kernel's exported
API under control.  What's the real downside?

 - R.
