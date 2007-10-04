Return-Path: <linux-kernel-owner+w=401wt.eu-S1761258AbXJDTVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761258AbXJDTVB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 15:21:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756659AbXJDTUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 15:20:52 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:50010 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756658AbXJDTUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 15:20:52 -0400
Date: Thu, 4 Oct 2007 12:20:50 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <ak@suse.de>
cc: akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, travis@sgi.com
Subject: Re: [13/18] x86_64: Allow fallback for the stack
In-Reply-To: <200710041356.51750.ak@suse.de>
Message-ID: <Pine.LNX.4.64.0710041220010.12075@schroedinger.engr.sgi.com>
References: <20071004035935.042951211@sgi.com> <20071004040004.708466159@sgi.com>
 <200710041356.51750.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Oct 2007, Andi Kleen wrote:

> We've known for ages that it is possible. But it has been always so rare
> that it was ignored.

Well we can now address the rarity. That is the whole point of the 
patchset.

> Is there any evidence this is more common now than it used to be?

It will be more common if the stack size is increased beyond 8k.


