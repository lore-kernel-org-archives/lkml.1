Return-Path: <linux-kernel-owner+w=401wt.eu-S1754844AbYCNGft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844AbYCNGft (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 02:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751491AbYCNGfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 02:35:41 -0400
Received: from relay2.sgi.com ([192.48.171.30]:49208 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751333AbYCNGfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 02:35:40 -0400
Date: Thu, 13 Mar 2008 23:34:47 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: hackbench regression since 2.6.25-rc
In-Reply-To: <1205465447.3215.195.camel@ymzhang>
Message-ID: <Pine.LNX.4.64.0803132333020.24204@schroedinger.engr.sgi.com>
References: <1205394417.3215.85.camel@ymzhang>  <20080313014808.f8d25c2a.akpm@linux-foundation.org>
  <1205400538.3215.148.camel@ymzhang>  <Pine.LNX.4.64.0803131714130.22519@schroedinger.engr.sgi.com>
  <1205463842.3215.188.camel@ymzhang> <1205465447.3215.195.camel@ymzhang>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2008, Zhang, Yanmin wrote:

> > So block 192 and 512's and very active and their fast free percentage 
> > is low.
> On my 8-core stoakley, there is no such regression. Below data is after testing.

Ok get the detailed statistics for this configuration as well. Then we 
can see what kind of slub behavior changes between both configurations.

The 16p is really one node? No strange variances in memory latencies? 

