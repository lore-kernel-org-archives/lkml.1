Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab0BEMQa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 07:16:30 -0500
Received: from casper.infradead.org ([85.118.1.10]:51822 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262Ab0BEMQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 07:16:29 -0500
Subject: Re: [PATCH 2/5] bitops: compile time optimization for
 hweight_long(CONSTANT)
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Brian Gerst <brgerst@gmail.com>
In-Reply-To: <20100205121139.GA9044@aftab>
References: <20100203070825.e36b3932.akpm@linux-foundation.org>
	 <1265210157.24455.646.camel@laptop>
	 <20100203074251.e2caa3f3.akpm@linux-foundation.org>
	 <20100203181425.GB1367@aftab> <1265222875.24455.1020.camel@laptop>
	 <4B69D362.10608@zytor.com> <20100204151050.GC32711@aftab>
	 <1265296432.22001.18.camel@laptop> <20100204155419.GD32711@aftab>
	 <1265299457.22001.72.camel@laptop>  <20100205121139.GA9044@aftab>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Feb 2010 13:14:59 +0100
Message-ID: <1265372099.22001.512.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-05 at 13:11 +0100, Borislav Petkov wrote:
> On Thu, Feb 04, 2010 at 05:04:17PM +0100, Peter Zijlstra wrote:
> > No, just don't touch hweight_long(), simply provide
> > __arch_hweight{8,16,32,64} and all will be well.
> 
> Ok, another day, another version :)
> 
> It is, of course, completely untested but it builds and the asm looks
> ok. I think I've addressed all concerns so far.

please work against a tree that has:

  http://lkml.org/lkml/2010/2/4/119

in.

