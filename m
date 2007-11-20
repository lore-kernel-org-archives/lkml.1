Return-Path: <linux-kernel-owner+w=401wt.eu-S1763937AbXKTUuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763937AbXKTUuf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 15:50:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762534AbXKTUuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 15:50:17 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36656 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763884AbXKTUuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 15:50:15 -0500
Date: Tue, 20 Nov 2007 12:50:14 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: ak@suse.de, akpm@linux-foundation.org, travis@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [rfc 12/45] cpu alloc: crash_notes conversion
In-Reply-To: <20071120130315.GF10127@Krystal>
Message-ID: <Pine.LNX.4.64.0711201249560.26745@schroedinger.engr.sgi.com>
References: <20071120011132.143632442@sgi.com> <20071120011334.564309282@sgi.com>
 <20071120130315.GF10127@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2007, Mathieu Desnoyers wrote:

> > -	buf = (u32*)per_cpu_ptr(crash_notes, cpu);
> > +	buf = (u32*)CPU_PTR(crash_notes, cpu);
> 
> Nitpick : (u32 *)

Yeah. I tend to leave the things as they were...
