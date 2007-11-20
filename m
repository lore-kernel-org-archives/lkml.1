Return-Path: <linux-kernel-owner+w=401wt.eu-S1762454AbXKTCOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762454AbXKTCOk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 21:14:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760908AbXKTCEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 21:04:05 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39456 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761077AbXKTCED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 21:04:03 -0500
Date: Mon, 19 Nov 2007 18:03:56 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "H. Peter Anvin" <hpa@zytor.com>
cc: ak@suse.de, akpm@linux-foundation.org, travis@sgi.com,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: [rfc 37/45] x86_64: Support for fast per cpu operations
In-Reply-To: <47423FB7.20800@zytor.com>
Message-ID: <Pine.LNX.4.64.0711191802270.19954@schroedinger.engr.sgi.com>
References: <20071120011132.143632442@sgi.com> <20071120011340.569486037@sgi.com>
 <47423FB7.20800@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Nov 2007, H. Peter Anvin wrote:

> There was, at some point, discussion about using the gcc TLS mechanism, which
> should permit even better code to be generated.  Unfortunately, it would

How would that be possible? Oh. You mean the discussion where I mentioned 
using the thread attribute?

> require gcc to be able to reference %gs instead of %fs (and vice versa for
> i386), which I don't think is available in anything except maybe the most
> cutting-edge version of gcc.

Right. That is why we do it in ASM here.

> However, if we're doing a masssive revampt it would be good to get an idea of
> how to migrate to that model eventually, or why it doesn't make sense at all.

If you can tell me what the difference would be then we can discuss it. 
AFAICT there is no difference. Both use a segment register.

