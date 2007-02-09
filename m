Return-Path: <linux-kernel-owner+w=401wt.eu-S1946266AbXBIKJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946266AbXBIKJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 05:09:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946265AbXBIKJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 05:09:47 -0500
Received: from mx2.suse.de ([195.135.220.15]:34123 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946266AbXBIKJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 05:09:45 -0500
From: Andi Kleen <ak@muc.de>
To: virtualization@lists.osdl.org
Subject: Re: [PATCH 2/10] lguest: Export symbols for lguest as a module
Date: Fri, 9 Feb 2007 10:32:44 +0100
User-Agent: KMail/1.9.5
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
References: <1171012296.2718.26.camel@localhost.localdomain> <1171012458.2718.30.camel@localhost.localdomain> <1171012513.2718.32.camel@localhost.localdomain>
In-Reply-To: <1171012513.2718.32.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702091032.44547.ak@muc.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 February 2007 10:15, Rusty Russell wrote:

> tsc_khz:
> 	Simplest way of telling the guest how to interpret the TSC
> 	counter.


Are you sure this will work with varying TSC frequencies? 

In general you should get this from cpufreq.

-Andi
