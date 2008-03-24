Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbYCXTz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbYCXTz1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 15:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbYCXTzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 15:55:07 -0400
Received: from relay1.sgi.com ([192.48.171.29]:53370 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753720AbYCXTzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 15:55:06 -0400
Date: Mon, 24 Mar 2008 12:53:19 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <andi@firstfloor.org>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [11/14] vcompound: Fallbacks for order 1 stack allocations on
 IA64 and x86
In-Reply-To: <871w63iuap.fsf@basil.nowhere.org>
Message-ID: <Pine.LNX.4.64.0803241251360.4218@schroedinger.engr.sgi.com>
References: <20080321061703.921169367@sgi.com> <20080321061726.782068299@sgi.com>
 <871w63iuap.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2008, Andi Kleen wrote:

> The traditional reason this was discouraged (people seem to reinvent
> variants of this patch all the time) was that there used 
> to be drivers that did __pa() (or equivalent) on stack addresses
> and that doesn't work with vmalloc pages.
> 
> I don't know if such drivers still exist, but such a change
> is certainly not a no-brainer

I thought that had been cleaned up because some arches already have 
virtually mapped stacks? This could be debugged by testing with
CONFIG_VFALLBACK_ALWAYS set. Which results in a stack that is always 
vmalloc'ed and thus the driver should fail.


