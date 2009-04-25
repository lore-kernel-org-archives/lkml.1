Return-Path: <linux-kernel-owner+w=401wt.eu-S1752267AbZDYFaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267AbZDYFaO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 01:30:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752175AbZDYF37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 01:29:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34139
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752003AbZDYF37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 01:29:59 -0400
Date: Fri, 24 Apr 2009 22:29:52 -0700 (PDT)
Message-Id: <20090424.222952.83381016.davem@davemloft.net>
To: cl@linux.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [rfc] built-in native compiler for Linux?
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.1.10.0904241429450.19686@qirst.com>
References: <20090422085828.GA16917@elte.hu>
	<alpine.DEB.1.10.0904241429450.19686@qirst.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <cl@linux.com>
Date: Fri, 24 Apr 2009 14:34:49 -0400 (EDT)

> On Wed, 22 Apr 2009, Ingo Molnar wrote:
> 
>> What i think makes sense is to build a _new_ precompiler / compiler
>> / assembler / linker combo for Linux, from scratch, hosted in the
>> kernel proper.
>>
>> A good technical basis for that would be Sparse, and it could start
>> by acting as a drop-in replacement for CPP and it could feed its
>> output to GCC with little changes. Sparse is small, has a very tidy
>> code base and is already useful today as an extended static source
>> code checker.
> 
> A new preprocessor would be great. If we can make sparse do what CPP does
> now then lets go for it.

It's just too bad that we'll lose the performance gained from the
fact that GCC's CPP is linked into the C compiler binary and thus
doesn't have to transfer it's result over a pipe or anything like
that.

I really think this whole idea isn't a very smart one.  I would
rather have whoever would be working on a sparse backend instead
be working on kernel improvements.

I also think people underestimate how much work this would be.
