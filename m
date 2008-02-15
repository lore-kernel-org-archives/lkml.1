Return-Path: <linux-kernel-owner+w=401wt.eu-S933049AbYBOW4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933049AbYBOW4x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 17:56:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933344AbYBOWnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 17:43:40 -0500
Received: from relay2.sgi.com ([192.48.171.30]:47192 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933324AbYBOWni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 17:43:38 -0500
Date: Fri, 15 Feb 2008 14:43:34 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: travis@sgi.com, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Jack Steiner <steiner@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] x86_64: Fold pda into per cpu area
In-Reply-To: <20080215201640.GA6200@elte.hu>
Message-ID: <Pine.LNX.4.64.0802151442440.16270@schroedinger.engr.sgi.com>
References: <20080201191414.961558000@sgi.com> <20080201191415.450555000@sgi.com>
 <20080215201640.GA6200@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2008, Ingo Molnar wrote:

> 
> * travis@sgi.com <travis@sgi.com> wrote:
> 
> >  include/asm-generic/vmlinux.lds.h |    2 +
> >  include/linux/percpu.h            |    9 ++++-
> 
> couldnt these two generic bits be done separately (perhaps a preparatory 
> but otherwise NOP patch pushed upstream straight away) to make 
> subsequent patches only touch x86 architecture files?

Yes those modifications could be folded into the generic patch for zero 
based percpu configurations.
