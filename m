Return-Path: <linux-kernel-owner+w=401wt.eu-S1755011AbYIESFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011AbYIESFj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 14:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751404AbYIESE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 14:04:59 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39131 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbYIESE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 14:04:57 -0400
To: Gary Hade <garyhade@us.ibm.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Badari Pulavarty <pbadari@us.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
       Chris McDermott <lcm@us.ibm.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] [RESEND] x86_64: add memory hotremove config option
From: Andi Kleen <andi@firstfloor.org>
References: <20080905172132.GA11692@us.ibm.com>
Date: Fri, 05 Sep 2008 20:04:55 +0200
In-Reply-To: <20080905172132.GA11692@us.ibm.com> (Gary Hade's message of "Fri, 5 Sep 2008 10:21:32 -0700")
Message-ID: <87ej3yv588.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gary Hade <garyhade@us.ibm.com> writes:
>
> Add memory hotremove config option to x86_64
>
> Memory hotremove functionality can currently be configured into
> the ia64, powerpc, and s390 kernels.  This patch makes it possible
> to configure the memory hotremove functionality into the x86_64
> kernel as well. 

You forgot to describe how you tested it? Does it actually work.
And why do you want to do it it? What's the use case?

The general understanding was that it doesn't work very well on a real
machine at least because it cannot be controlled how that memory maps
to real pluggable hardware (and you cannot completely empty a node at runtime)
and a Hypervisor would likely use different interfaces anyways.

-Andi
