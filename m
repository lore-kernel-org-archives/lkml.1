Return-Path: <linux-kernel-owner+w=401wt.eu-S1765682AbYARUKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765682AbYARUKU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 15:10:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762054AbYARUKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 15:10:07 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36194 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761370AbYARUKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 15:10:06 -0500
Date: Fri, 18 Jan 2008 12:10:00 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Oeser <ioe-lkml@rameria.de>
cc: travis@sgi.com, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>, mingo@elte.hu, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] x86: Add config variables for SMP_MAX
In-Reply-To: <200801182104.22486.ioe-lkml@rameria.de>
Message-ID: <Pine.LNX.4.64.0801181208520.31319@schroedinger.engr.sgi.com>
References: <20080118183011.354965000@sgi.com> <20080118183011.917801000@sgi.com>
 <200801182104.22486.ioe-lkml@rameria.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jan 2008, Ingo Oeser wrote:

> Hi Mike,
> 
> On Friday 18 January 2008, travis@sgi.com wrote:
> > +config THREAD_ORDER
> > +	int "Kernel stack size (in page order)"
> > +	range 1 3

THREAD_ORDER can also be used to consolidate the stack size with the 
choices available for i386. In that cases the choices are 0 and 1.
