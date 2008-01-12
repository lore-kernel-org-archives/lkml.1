Return-Path: <linux-kernel-owner+w=401wt.eu-S1760010AbYALShN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760010AbYALShN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 13:37:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759569AbYALSg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 13:36:59 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:51153 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759495AbYALSg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 13:36:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bBBgyc+dTLW9cb3FJSk5ZLZUtqs+e/TvhiJa4SMuuDZLCPEn3Ud0t3+9bnt+FUwdVcjtA6lyYEvKyzAXsGzlNNXfg7yhPFDmAOlM2bd3RCOu0uTPJinnGGPsmf/6HiNiqIM8sdWjXXqqR02d15GB8KdiqgcEQmV2KyQVAS8Re0Q=
Message-ID: <9f4f8abe0801121036gfdc14fctdbcc075ac6ae91c4@mail.gmail.com>
Date: Sat, 12 Jan 2008 10:36:57 -0800
From: "Vineet Gupta" <vineetg76@gmail.com>
To: "Chris Snook" <csnook@redhat.com>
Subject: Re: Usage semantics of atomic_set ( )
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <478819EA.2080905@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9f4f8abe0801111457t7535069ar1f98cc37d5cf8d40@mail.gmail.com>
	 <478819EA.2080905@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What operations are you using to implement spinlocks?

The cpu provides atomic exchange instruction (atomic Read/write
semantics) which forms the back end of spin lock code.
__raw_spin_trylock( ) atomically swaps the lock memory with a reg (set
to 1)

Using a pool of spinlocks rather that original idea of spinlock per
atomic_t anyways seems to be a better idea.
I really appreciate the responses. Thanks a lot

-Vineet
