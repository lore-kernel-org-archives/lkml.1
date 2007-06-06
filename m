Return-Path: <linux-kernel-owner+w=401wt.eu-S935008AbXFFTma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935008AbXFFTma (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 15:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665AbXFFTmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 15:42:23 -0400
Received: from holomorphy.com ([66.93.40.71]:53814 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399AbXFFTmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 15:42:23 -0400
Date: Wed, 6 Jun 2007 12:43:29 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm1
Message-ID: <20070606194329.GO6909@holomorphy.com>
References: <20070606020737.4663d686.akpm@linux-foundation.org> <20070606163053.GM6909@holomorphy.com> <20070606111315.884cf712.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070606111315.884cf712.akpm@linux-foundation.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2007 09:30:53 -0700 William Lee Irwin III <wli@holomorphy.com> wrote:
>> Something brings down i386/qemu before even earlyprintk can handle.
>> Bisection has narrowed it down to patch 1140 after everything got
>> renumbered by peterz' fix for mm-variable-length-argument-support.patch,
>> namely containersv10-make-cpusets-a-client-of-containers.patch

On Wed, Jun 06, 2007 at 11:13:15AM -0700, Andrew Morton wrote:
> erk.  A step-by-step how-to-make-this-happen might help if poss, please.

(1) build for i386 with my .config
(2) attempt to boot in qemu's i386 system simulator

I'm not seeing the sort of nondeterminism Andy Whitcroft is. It breaks
every time when I try this.


-- wli
