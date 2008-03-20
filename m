Return-Path: <linux-kernel-owner+w=401wt.eu-S1163355AbYCTAcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163355AbYCTAcz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:32:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S943992AbYCTAEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 20:04:47 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56533 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S943985AbYCTAEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 20:04:45 -0400
Date: Wed, 19 Mar 2008 17:03:17 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2/2] vmallocinfo: Add caller information
In-Reply-To: <20080319214227.GA4454@elte.hu>
Message-ID: <Pine.LNX.4.64.0803191659410.4645@schroedinger.engr.sgi.com>
References: <20080318222701.788442216@sgi.com> <20080318222827.519656153@sgi.com>
 <20080319214227.GA4454@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Mar 2008, Ingo Molnar wrote:

> 
> * Christoph Lameter <clameter@sgi.com> wrote:
> 
> > Add caller information so that /proc/vmallocinfo shows where the 
> > allocation request for a slice of vmalloc memory originated.
> 
> please use one simple save_stack_trace() instead of polluting a dozen 
> architectures with:

save_stack_trace() depends on CONFIG_STACKTRACE which is only available 
when debugging is compiled it. I was more thinking about this as a 
generally available feature.


