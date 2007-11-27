Return-Path: <linux-kernel-owner+w=401wt.eu-S1759260AbXK0SQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759260AbXK0SQr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 13:16:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756367AbXK0SQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 13:16:40 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:44990 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756242AbXK0SQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 13:16:40 -0500
Date: Tue, 27 Nov 2007 10:16:39 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Kumar Gala <galak@kernel.crashing.org>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [patch 11/14] Powerpc: Use generic per cpu
In-Reply-To: <F81BD9A7-9D76-4C2C-AF80-AAA3F70F061E@kernel.crashing.org>
Message-ID: <Pine.LNX.4.64.0711271016260.2310@schroedinger.engr.sgi.com>
References: <20071127001407.859743255@sgi.com> <20071127001431.688565525@sgi.com>
 <F81BD9A7-9D76-4C2C-AF80-AAA3F70F061E@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Nov 2007, Kumar Gala wrote:

> > Index: linux-2.6/include/asm-powerpc/percpu.h
> > ===================================================================
> > --- linux-2.6.orig/include/asm-powerpc/percpu.h	2007-11-24
> > 10:27:31.088350556 -0800
> > +++ linux-2.6/include/asm-powerpc/percpu.h	2007-11-24 10:29:20.752350757
> > -0800
> > @@ -16,25 +16,6 @@
> > #define __my_cpu_offset() get_paca()->data_offset
> > #define per_cpu_offset(x) (__per_cpu_offset(x))
> 
> This concerns me.  paca doesn't exist on all PPC platforms.

I wonder why the current code is working then.

