Return-Path: <linux-kernel-owner+w=401wt.eu-S1758913AbYCUWbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913AbYCUWbL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 18:31:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753330AbYCUWa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:30:57 -0400
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:4564 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbYCUWa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:30:57 -0400
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [11/14] vcompound: Fallbacks for order 1 stack allocations on IA64 and x86
References: <20080321061703.921169367@sgi.com>
	<20080321061726.782068299@sgi.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 21 Mar 2008 23:30:54 +0100
In-Reply-To: <20080321061726.782068299@sgi.com>
Message-ID: <871w63iuap.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 21 Mar 2008 22:24:18.0190 (UTC) FILETIME=[4D89D2E0:01C88BA2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter <clameter@sgi.com> writes:

> This allows fallback for order 1 stack allocations. In the fallback
> scenario the stacks will be virtually mapped.

The traditional reason this was discouraged (people seem to reinvent
variants of this patch all the time) was that there used 
to be drivers that did __pa() (or equivalent) on stack addresses
and that doesn't work with vmalloc pages.

I don't know if such drivers still exist, but such a change
is certainly not a no-brainer

-Andi
