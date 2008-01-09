Return-Path: <linux-kernel-owner+w=401wt.eu-S1755364AbYAIT3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbYAIT3Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 14:29:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbYAIT3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 14:29:17 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:55532 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120AbYAIT3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 14:29:16 -0500
Subject: Re: [PATCH 10/10] x86: Unify percpu.h
From: Dave Hansen <haveblue@us.ibm.com>
To: travis@sgi.com
Cc: Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>,
       Jack Steiner <steiner@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       tglx@linutronix.de, mingo@redhat.com
In-Reply-To: <20080108211025.293924000@sgi.com>
References: <20080108211023.923047000@sgi.com>
	 <20080108211025.293924000@sgi.com>
Content-Type: text/plain
Date: Wed, 09 Jan 2008 11:28:24 -0800
Message-Id: <1199906905.9834.101.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-01-08 at 13:10 -0800, travis@sgi.com wrote:
> Form a single percpu.h from percpu_32.h and percpu_64.h. Both are now pretty
> small so this is simply adding them together. 

I guess I just don't really see the point of moving the code around like
this.  Before, it would have been easier to tell at a glance before
whether you were looking at 32 or 64-bit code because of which file you
are in.  But, now, you need to look for #ifdef context.  I'm not sure
that's a win.

This only saves 5 net lines of code, and those are probably from:

-#ifndef __ARCH_I386_PERCPU__
-#define __ARCH_I386_PERCPU__

right?

The rest of the set looks brilliant, though.  

-- Dave

