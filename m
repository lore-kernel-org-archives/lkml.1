Return-Path: <linux-kernel-owner+w=401wt.eu-S1030480AbXECIyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030480AbXECIyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 04:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030477AbXECIyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 04:54:18 -0400
Received: from cantor.suse.de ([195.135.220.2]:49155 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030480AbXECIyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 04:54:17 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ulrich Drepper <drepper@redhat.com>
Subject: Re: Why ssse3?
Date: Thu, 3 May 2007 10:52:31 +0200
User-Agent: KMail/1.9.6
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <46391392.4070706@redhat.com> <200705030046.07152.ak@suse.de> <4639171A.3050004@redhat.com>
In-Reply-To: <4639171A.3050004@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705031052.31611.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 May 2007 00:56:26 Ulrich Drepper wrote:
> Andi Kleen wrote:
> > Nope. SSE3 != SSSE3. The additional S means Supplemential.
> > 
> > It's probably because the few changes didn't justify a SSE4
> 
> OK, the problem is that the actual sse3 bit is misnamed.  According to
> Intel's docs bit 0 of ECX is "sse", the kernel uses "pni".  Too bad.

PNI (Prescott New Instructions) was the original engineering code name. Unfortunately
it was added too early before the marketing name was known and then it couldn't be 
changed anymore.

-Andi

