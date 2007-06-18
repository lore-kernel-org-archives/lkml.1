Return-Path: <linux-kernel-owner+w=401wt.eu-S1762336AbXFRQRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762336AbXFRQRV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 12:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758633AbXFRQRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 12:17:14 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58415 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758430AbXFRQRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 12:17:13 -0400
Date: Mon, 18 Jun 2007 09:17:11 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Paul Mundt <lethal@linux-sh.org>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       suresh.b.siddha@intel.com
Subject: Re: [patch 04/26] Slab allocators: Support __GFP_ZERO in all
 allocators.
In-Reply-To: <20070618100909.GB19056@linux-sh.org>
Message-ID: <Pine.LNX.4.64.0706180915320.4529@schroedinger.engr.sgi.com>
References: <20070618095838.238615343@sgi.com> <20070618095914.332369986@sgi.com>
 <20070618100909.GB19056@linux-sh.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2007, Paul Mundt wrote:

> On Mon, Jun 18, 2007 at 02:58:42AM -0700, clameter@sgi.com wrote:
> > So add the necessary logic to all slab allocators to support __GFP_ZERO.
> > 
> Does this mean I should update my SLOB NUMA support patch? ;-)

Hehehe. Its not merged yet. Sorry about the fluidity here. The 
discussion with you triggered some thought processes on the 
consistency issues with zeroing in allocators.


