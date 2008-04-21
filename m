Return-Path: <linux-kernel-owner+w=401wt.eu-S1755119AbYDUF7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119AbYDUF7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 01:59:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918AbYDUF7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 01:59:00 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52315 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751913AbYDUF67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 01:58:59 -0400
Date: Sun, 20 Apr 2008 22:58:58 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka J Enberg <penberg@cs.helsinki.fi>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [bug] SCSI/SLUB - latest -git: WARNING: at mm/slub.c:2443
 kmem_cache_destroy, scsi_put_host_cmd_pool()
In-Reply-To: <Pine.LNX.4.64.0804191208430.25553@sbz-30.cs.Helsinki.FI>
Message-ID: <Pine.LNX.4.64.0804202257120.13872@schroedinger.engr.sgi.com>
References: <20080419085758.GA18612@elte.hu> <Pine.LNX.4.64.0804191208430.25553@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Apr 2008, Pekka J Enberg wrote:

> > [a few .config options were turned off: just accept all the defaults 
> >  after 'make oldconfig']
> 
> I couldn't spot anything in particular in SLUB which makes me think SCSI 
> code simply didn't free all objects before scsi_put_host_cmd_pool() called 
> kmem_cache_destroy() to kill the cache.
> 
> James, does this make sense or should I just look at SLUB harder?

The WARN is intended to warn that a kmem_cache_destroy was run with 
objects not freed.



