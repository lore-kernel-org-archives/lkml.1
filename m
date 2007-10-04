Return-Path: <linux-kernel-owner+w=401wt.eu-S1759147AbXJDL7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759147AbXJDL7b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 07:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755239AbXJDL7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 07:59:23 -0400
Received: from ns2.suse.de ([195.135.220.15]:46142 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755724AbXJDL7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 07:59:22 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [13/18] x86_64: Allow fallback for the stack
Date: Thu, 4 Oct 2007 13:56:51 +0200
User-Agent: KMail/1.9.6
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, travis@sgi.com
References: <20071004035935.042951211@sgi.com> <20071004040004.708466159@sgi.com>
In-Reply-To: <20071004040004.708466159@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710041356.51750.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 October 2007 05:59:48 Christoph Lameter wrote:
> Peter Zijlstra has recently demonstrated that we can have order 1 allocation
> failures under memory pressure with small memory configurations. The
> x86_64 stack has a size of 8k and thus requires a order 1 allocation.

We've known for ages that it is possible. But it has been always so rare
that it was ignored.

Is there any evidence this is more common now than it used to be?

-Andi
