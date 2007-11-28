Return-Path: <linux-kernel-owner+w=401wt.eu-S1760972AbXK1Caj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760972AbXK1Caj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 21:30:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760144AbXK1C3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 21:29:44 -0500
Received: from ozlabs.org ([203.10.76.45]:41086 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759596AbXK1C3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 21:29:39 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH RFC] [1/9] Core module symbol namespaces code and intro.
Date: Wed, 28 Nov 2007 12:34:02 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Roland Dreier <rdreier@cisco.com>, Andi Kleen <ak@suse.de>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, sam@ravnborg.org
References: <20071122343.446909000@suse.de> <200711271526.53065.rusty@rustcorp.com.au> <20071127105016.GC24223@one.firstfloor.org>
In-Reply-To: <20071127105016.GC24223@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711281234.03381.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 November 2007 21:50:16 Andi Kleen wrote:
> Goals are:
> - Limit the interfaces available for out of tree modules to reasonably
> stable ones that are already used by a larger set of drivers.

Not the goals.  I haven't seen the *problem* yet.

> - Limit size of exported API to make stable ABIs for enterprise
> distributions easier
> [Yes I know that is not a popular topic on l-k, but it's a day-to-day
> problem for these distros and out of tree solutions do not work]

That's a real problem, and I sympathise with the idea of marking symbols as 
externally useful (or, practically, mark internal).

But we now need to decide what's "externally useful".  The currently line for 
exports is simple: someone in-tree needs it.  You dislike the suggestion to 
extend this to "if more than one in-tree needs it it's open".

Currently your criterion seems to be "does the maintainer hate external 
modules?" which I don't think will be what you want...

Cheers,
Rusty.
