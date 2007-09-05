Return-Path: <linux-kernel-owner+w=401wt.eu-S1756337AbXIEHHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337AbXIEHHk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 03:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754175AbXIEHHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 03:07:32 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:48526 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752773AbXIEHHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 03:07:31 -0400
Date: Wed, 5 Sep 2007 00:07:30 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
cc: LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu
Subject: Re: tbench regression - Why process scheduler has impact on tbench
 and why small per-cpu slab (SLUB) cache creates the scenario?
In-Reply-To: <1188969725.26438.46.camel@ymzhang>
Message-ID: <Pine.LNX.4.64.0709050006330.7567@schroedinger.engr.sgi.com>
References: <1188953218.26438.34.camel@ymzhang> 
 <Pine.LNX.4.64.0709042053320.7231@schroedinger.engr.sgi.com>
 <1188969725.26438.46.camel@ymzhang>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Sep 2007, Zhang, Yanmin wrote:

> > slub_max_order=3 slub_min_objects=8
> I tried this approach. The testing result showed 2.6.23-rc4 is about
> 2.5% better than 2.6.22. It really resovles the issue.

Note also that the configuration you tried is the way SLUB is configured 
in Andrew's tree.
