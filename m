Return-Path: <linux-kernel-owner+w=401wt.eu-S1759709AbXK0VN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759709AbXK0VN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 16:13:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757241AbXK0VNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 16:13:21 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42402 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756902AbXK0VNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 16:13:21 -0500
Date: Tue, 27 Nov 2007 13:13:20 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Paul Mackerras <paulus@samba.org>
cc: Kumar Gala <galak@kernel.crashing.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 11/14] Powerpc: Use generic per cpu
In-Reply-To: <18252.34032.207280.742887@cargo.ozlabs.ibm.com>
Message-ID: <Pine.LNX.4.64.0711271311370.4590@schroedinger.engr.sgi.com>
References: <20071127001407.859743255@sgi.com> <20071127001431.688565525@sgi.com>
 <F81BD9A7-9D76-4C2C-AF80-AAA3F70F061E@kernel.crashing.org>
 <Pine.LNX.4.64.0711271016260.2310@schroedinger.engr.sgi.com>
 <18252.34032.207280.742887@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Nov 2007, Paul Mackerras wrote:

> Did you try both 32-bit (CONFIG_64BIT=n) and 64-bit (CONFIG_64BIT=y)
> configurations?  The paca only exists in 64-bit kernels.

I build both and there is no dependency on 32bit or 64 bit in 
include/asm-powerpc/percpu.h. Both access the paca (whatever that is).

