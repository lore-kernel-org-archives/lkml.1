Return-Path: <linux-kernel-owner+w=401wt.eu-S1756608AbYJNDr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608AbYJNDr4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 23:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754741AbYJNDrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 23:47:47 -0400
Received: from gate.crashing.org ([63.228.1.57]:34174 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754467AbYJNDrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 23:47:47 -0400
Subject: Re: [PATCH] Fix broken debug output reserve_region_with_split()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       yhlu.kernel@gmail.com
In-Reply-To: <48F409E9.3030501@zytor.com>
References: <20081014005428.EC2D8DDF93@ozlabs.org>
	 <48F3F014.3050406@zytor.com> <1223948488.8157.309.camel@pasglop>
	 <48F409E9.3030501@zytor.com>
Content-Type: text/plain
Date: Tue, 14 Oct 2008 14:47:31 +1100
Message-Id: <1223956051.8157.320.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Linus already posted a patch.  He took a struct resource
> and printed it as a range.  I pointed out that we should use the flags 
> to determine formatting options, e.g. I/O space is only 16 bits on x86.

And x86 only please :-)

Allright, let's dig it out. The reason I wasn't too sure about what to
do with resources was whether to have it also print the name and flags,
since there's quite a few areas where were really don't care.

Cheers,
Ben.

