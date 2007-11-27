Return-Path: <linux-kernel-owner+w=401wt.eu-S1755542AbXK0Eaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbXK0Eaz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 23:30:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555AbXK0Eas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 23:30:48 -0500
Received: from ozlabs.org ([203.10.76.45]:45372 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541AbXK0Ear (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 23:30:47 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [patch 05/14] percpu: Use a Kconfig variable to configure arch specific percpu setup
Date: Tue, 27 Nov 2007 15:30:47 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
References: <20071127001407.859743255@sgi.com> <20071127001430.313046247@sgi.com>
In-Reply-To: <20071127001430.313046247@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711271530.47696.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 November 2007 11:14:12 Christoph Lameter wrote:
> The use of the __GENERIC_PERCPU is a bit problematic since arches
> may want to run their own percpu setup while using the generic
> percpu definitions. Replace it through a kconfig variable.

Thanks for this Christoph!

These patches are great: the early experiments are obviously over, and so this 
consolidation is overdue.

Have you considered moving x86-64's setup_per_cpu_areas into generic code?  
It's a bit messier because some archs might not have set up NUMA stuff yet, 
but it's logically generic...

Thanks!
Rusty.
