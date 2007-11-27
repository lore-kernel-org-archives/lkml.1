Return-Path: <linux-kernel-owner+w=401wt.eu-S1758697AbXK0SO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758697AbXK0SO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 13:14:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756005AbXK0SOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 13:14:49 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:44772 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754723AbXK0SOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 13:14:48 -0500
Date: Tue, 27 Nov 2007 10:14:47 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Rusty Russell <rusty@rustcorp.com.au>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: [patch 05/14] percpu: Use a Kconfig variable to configure arch
 specific percpu setup
In-Reply-To: <200711271530.47696.rusty@rustcorp.com.au>
Message-ID: <Pine.LNX.4.64.0711271013130.2310@schroedinger.engr.sgi.com>
References: <20071127001407.859743255@sgi.com> <20071127001430.313046247@sgi.com>
 <200711271530.47696.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Nov 2007, Rusty Russell wrote:

> Have you considered moving x86-64's setup_per_cpu_areas into generic code?  
> It's a bit messier because some archs might not have set up NUMA stuff yet, 
> but it's logically generic...

Yes that will happen later. This is just the early cleanup work. I 
plan to generally bring the two x86 arches in line. The pda will be 
folded into the per cpu area and after that its easy to do.

