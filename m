Return-Path: <linux-kernel-owner+w=401wt.eu-S935425AbZJOUJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935425AbZJOUJX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 16:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935405AbZJOUJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 16:09:23 -0400
Received: from gate.crashing.org ([63.228.1.57]:47177 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935391AbZJOUJW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 16:09:22 -0400
Subject: Re: powerpc problem with .data.page_aligned -> __page_aligned_data
 conversion
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Tim Abbott <tabbott@ksplice.com>
Cc: sam@ravnborg.org, linuxppc-dev@lists.ozlabs.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0910151229340.25434@dr-wily.mit.edu>
References: <1255584772.2347.86.camel@pasglop>
	 <alpine.DEB.1.10.0910151229340.25434@dr-wily.mit.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Oct 2009 07:00:09 +1100
Message-Id: <1255636809.2347.103.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-15 at 12:37 -0400, Tim Abbott wrote:
> Just to make sure I understand the nature of the problem, is the
> current 
> breakage that gcc < 4.3 will _warn_ on any compilation units on ppc64
> that 
> use __page_aligned data, or something worse?
> 
> The cropping is clearly a potential problem, but I read the rest of
> your 
> email as saying that the cropping of the alignment isn't actually a 
> problem with the current kernel because the kernel is currently only
> using 
> the macro with things whose size is divisible by PAGE_SIZE.  However,
> I am 
> not sure how to reconcile that with using the word "break" above...

Break is because we use -Werror on arch/powerpc :-)

Ben.


