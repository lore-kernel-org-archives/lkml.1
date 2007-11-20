Return-Path: <linux-kernel-owner+w=401wt.eu-S1763181AbXKTUhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763181AbXKTUhO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 15:37:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761276AbXKTUg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 15:36:58 -0500
Received: from relay1.sgi.com ([192.48.171.29]:55121 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761146AbXKTUg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 15:36:57 -0500
Date: Tue, 20 Nov 2007 12:36:57 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: ak@suse.de, akpm@linux-foundation.org, travis@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [rfc 03/45] Generic CPU operations: Core piece
In-Reply-To: <20071120040729.GA25013@Krystal>
Message-ID: <Pine.LNX.4.64.0711201235430.26745@schroedinger.engr.sgi.com>
References: <20071120011132.143632442@sgi.com> <20071120011332.415903723@sgi.com>
 <20071120031751.GA21743@Krystal> <Pine.LNX.4.64.0711191927510.21689@schroedinger.engr.sgi.com>
 <20071120040729.GA25013@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Nov 2007, Mathieu Desnoyers wrote:

> > But (x) is returned to the "caller" of the macro so it should be specially 
> > marged.
> > 
> 
> I don't think that it really matters.. the preprocessor already wraps
> all the ({ }) in a single statement, doesn't it ?

No it does not matter for the preprocessor. It matters for readability 
because I want to see that this is the return value.

> Since checkpatch.pl emits a warning when a one liner if() uses brackets,
> I guess compactness of code is preferred to a consistent style.

I wish someone would fix it. Its giving so much false positives that its 
useless for me.
