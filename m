Return-Path: <linux-kernel-owner+w=401wt.eu-S938012AbYEUVSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938012AbYEUVSl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 17:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752698AbYEUVSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 17:18:30 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33010 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750899AbYEUVS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 17:18:29 -0400
Date: Wed, 21 May 2008 14:18:29 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: linux-kernel@vger.kernel.org, mpm@selenic.com, lethal@linux-sh.org,
       dhowells@redhat.com
Subject: Re: [RFC/PATCH 2/3] SLUB: make ksize() more strict for page allocator
 pass-through
In-Reply-To: <4834704D.6020809@cs.helsinki.fi>
Message-ID: <Pine.LNX.4.64.0805211417340.17976@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0805212125310.22291@sbz-30.cs.Helsinki.FI>
 <Pine.LNX.4.64.0805211149210.16064@schroedinger.engr.sgi.com>
 <4834704D.6020809@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008, Pekka Enberg wrote:

> Hmm, where? page_address() already references ->virtual. I suppose

The ->virtual case is a very special case. page_address() currently should 
reduce to a simple shift and an add with VMEMMAP.

