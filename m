Return-Path: <linux-kernel-owner+w=401wt.eu-S1764304AbXK3Snv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764304AbXK3Snv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 13:43:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932215AbXK3Sni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 13:43:38 -0500
Received: from relay1.sgi.com ([192.48.171.29]:57636 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756713AbXK3Snh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 13:43:37 -0500
Date: Fri, 30 Nov 2007 10:43:36 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 0/3] Per cpu relocation to ZERO and x86_32 percpu ops on
 x86_64
In-Reply-To: <20071130184114.GA9928@elte.hu>
Message-ID: <Pine.LNX.4.64.0711301042550.1919@schroedinger.engr.sgi.com>
References: <20071130064305.459255715@sgi.com> <20071130112429.GA3605@elte.hu>
 <20071130112645.GA7565@elte.hu> <Pine.LNX.4.64.0711300918250.32294@schroedinger.engr.sgi.com>
 <20071130180002.GB19571@elte.hu> <Pine.LNX.4.64.0711301019590.1743@schroedinger.engr.sgi.com>
 <20071130184114.GA9928@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2007, Ingo Molnar wrote:

> such as? I guess these two:
> 
> mm-prevent-dereferencing-non-allocated-per_cpu-variables.patch
> mm-prevent-dereferencing-non-allocated-per_cpu-variables-fix.patch
> 
> would be needed too?

I sent another list in an earlier email. AFAICT the above does not matter.

Early boot interactions with lockdep may be an issue if that is enabled.


