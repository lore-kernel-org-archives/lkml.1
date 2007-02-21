Return-Path: <linux-kernel-owner+w=401wt.eu-S1422773AbXBUS2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422773AbXBUS2a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 13:28:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422775AbXBUS2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 13:28:30 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:43588 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1422773AbXBUS23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 13:28:29 -0500
Date: Wed, 21 Feb 2007 10:28:28 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: akpm@linux-foundation.org, mcr@sandelman.ca, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: ensure cache_alloc_refill terminates
In-Reply-To: <84144f020702211022h10dd36c4n74837169a7b211ef@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0702211028120.24719@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0702211029340.9758@sbz-30.cs.Helsinki.FI> 
 <Pine.LNX.4.64.0702210950310.24344@schroedinger.engr.sgi.com>
 <84144f020702211022h10dd36c4n74837169a7b211ef@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Feb 2007, Pekka Enberg wrote:

> ...and batchcount is not decremented and we're effectively in an
> infinite loop. Or am I missing something here?

No you are right.

Acked-by: Christoph Lameter <clameter@sgi.com>

