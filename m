Return-Path: <linux-kernel-owner+w=401wt.eu-S1758608AbZE1GxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608AbZE1GxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 02:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751114AbZE1GxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 02:53:09 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:55307 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbZE1GxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 02:53:08 -0400
Date: Thu, 28 May 2009 16:42:38 +1000
From: David Gibson <dwg@au1.ibm.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>, maneesh@linux.vnet.ibm.com,
       Roland McGrath <roland@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [Patch 06/12] Use the new wrapper routines to access debug
	registers in process/thread code
Message-ID: <20090528064238.GC3091@yookeroo.seuss>
Mail-Followup-To: David Gibson <dwg@au1.ibm.com>,
	"K.Prasad" <prasad@linux.vnet.ibm.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Steven Rostedt <rostedt@goodmis.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Ingo Molnar <mingo@elte.hu>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Benjamin Herrenschmidt <benh@au1.ibm.com>,
	maneesh@linux.vnet.ibm.com, Roland McGrath <roland@redhat.com>,
	Masami Hiramatsu <mhiramat@redhat.com>
References: <20090511114422.133566343@prasadkr_t60p.in.ibm.com> <20090511115344.GG25673@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090511115344.GG25673@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 05:23:44PM +0530, K.Prasad wrote:
> From: Alan Stern <stern@rowland.harvard.edu>
> 
> This patch enables the use of abstract debug registers in
> process-handling routines.

[snip]
>  
> +	p->thread.io_bitmap_ptr = NULL;

Why is manipulating the io_bitmap_ptr relevant to debug register
handling?

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
