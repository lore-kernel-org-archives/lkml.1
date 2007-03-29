Return-Path: <linux-kernel-owner+w=401wt.eu-S934283AbXC2A7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934283AbXC2A7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 20:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934286AbXC2A67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 20:58:59 -0400
Received: from holomorphy.com ([66.93.40.71]:37685 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934283AbXC2A67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 20:58:59 -0400
Date: Wed, 28 Mar 2007 17:59:02 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [RFC] i386: Remove page sized slabs for pgds and pmds
Message-ID: <20070329005902.GH2986@holomorphy.com>
References: <Pine.LNX.4.64.0703281309210.12985@schroedinger.engr.sgi.com> <20070328205055.GX8915@holomorphy.com> <Pine.LNX.4.64.0703281356080.13258@schroedinger.engr.sgi.com> <20070328212459.GY8915@holomorphy.com> <Pine.LNX.4.64.0703281435330.14017@schroedinger.engr.sgi.com> <20070328220131.GF2986@holomorphy.com> <20070329012859.53bef09a@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070329012859.53bef09a@the-village.bc.nu>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2007 at 02:38:55PM -0700, Christoph Lameter wrote:
>>> No that was described in the patch. Quote:
>>> "i386 only provides support for caching constructed pgd and pmds. These 
>>> are comparatively rare to ptes so it is no surprise that the current 
>>> approach has only minimal effect. ...."

On Thu, Mar 29, 2007 at 01:28:59AM +0100, Alan Cox wrote:
> Whatever it was originally for and public or not, the above isn't true
> for some non Intel products...

Sorry if the descriptions here are misleading. This is basically an
attempt to have the kernel keep preconstructed pagetables around so
that the bitblitting hits need not be repetitively taken during fork()
and faults, where counterarguments revolve around whether this is
actually a hit at all and whether it's significant. It's not related to
the transparent quasi-ASID/ASN affairs AMD has based on %cr3 contents.


-- wli
