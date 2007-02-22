Return-Path: <linux-kernel-owner+w=401wt.eu-S1751631AbXBVPUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631AbXBVPUJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 10:20:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633AbXBVPUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 10:20:08 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:34912 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751631AbXBVPUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 10:20:07 -0500
Date: Thu, 22 Feb 2007 07:20:05 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mpm@selenic.com,
       jsipek@fsl.cs.sunysb.edu
Subject: Re: [PATCH 1/2] slab: introduce krealloc
In-Reply-To: <Pine.LNX.4.64.0702221439140.14523@sbz-30.cs.Helsinki.FI>
Message-ID: <Pine.LNX.4.64.0702220719460.757@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0702221439140.14523@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Feb 2007, Pekka J Enberg wrote:

> This introduce krealloc() that reallocates memory while keeping the
> contents unchanged. The allocator avoids reallocation if the new size
> fits the currently used cache. I also added a simple non-optimized
> version for mm/slob.c for compatibility.

Acked-by: Christoph Lameter <clameter@sgi.com>
