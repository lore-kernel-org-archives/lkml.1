Return-Path: <linux-kernel-owner+w=401wt.eu-S1762466AbYEWAEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762466AbYEWAEo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 20:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759144AbYEWAEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 20:04:35 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42303 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754400AbYEWAEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 20:04:34 -0400
Date: Thu, 22 May 2008 17:04:34 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Paul Mundt <lethal@linux-sh.org>
cc: Pekka J Enberg <penberg@cs.helsinki.fi>, dhowells@redhat.com,
       mpm@selenic.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nommu: fix kobjsize() for SLOB and SLUB
In-Reply-To: <20080522235032.GA22697@linux-sh.org>
Message-ID: <Pine.LNX.4.64.0805221703500.30480@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0805221907250.4056@sbz-30.cs.Helsinki.FI>
 <20080522234036.GA18434@linux-sh.org> <Pine.LNX.4.64.0805221644470.30217@schroedinger.engr.sgi.com>
 <20080522235032.GA22697@linux-sh.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2008, Paul Mundt wrote:

> Ah, so it does. In that case, we still need to kill off the page->index
> BUG_ON() bits, while PageCompound() will take care of the compound order
> bits that the page->index shifting seems to have been trying to
> implement, the BUG_ON() will still trigger for PAGE_SIZE page cache
> pages.

Yes. I have no idea what the page->index check does there. The compound 
page order is not stored in the index field.
 
