Return-Path: <linux-kernel-owner+w=401wt.eu-S936375AbXHOUAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936375AbXHOUAs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 16:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932988AbXHOT7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 15:59:38 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:59661 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S936207AbXHOT7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 15:59:37 -0400
Date: Wed, 15 Aug 2007 12:59:32 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <ak@suse.de>
cc: Ralf Baechle <ralf@linux-mips.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Mel Gorman <mel@skynet.ie>, Lee.Schermerhorn@hp.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-mips@linux-mips.org
Subject: Re: [PATCH 3/4] Embed zone_id information within the zonelist->zones
 pointer
In-Reply-To: <20070815125920.GD3406@bingen.suse.de>
Message-ID: <Pine.LNX.4.64.0708151259230.7326@schroedinger.engr.sgi.com>
References: <20070813225841.GG3406@bingen.suse.de>
 <Pine.LNX.4.64.0708131506030.28502@schroedinger.engr.sgi.com>
 <20070813230801.GH3406@bingen.suse.de> <Pine.LNX.4.64.0708131536340.29946@schroedinger.engr.sgi.com>
 <20070813234322.GJ3406@bingen.suse.de> <Pine.LNX.4.64.0708131553050.30626@schroedinger.engr.sgi.com>
 <20070814000041.GL3406@bingen.suse.de> <20070814002223.2d8d42c5@the-village.bc.nu>
 <20070814001441.GN3406@bingen.suse.de> <20070815113749.GA5862@linux-mips.org>
 <20070815125920.GD3406@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Aug 2007, Andi Kleen wrote:

> BTW I suspect this is true for some other GFP_DMA usages too.
> Some driver writers seem to confuse it with the PCI DMA
> APIs or believe it is always needed for them.

See especially ARM.

