Return-Path: <linux-kernel-owner+w=401wt.eu-S1751951AbXB0WYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951AbXB0WYl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 17:24:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbXB0WYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 17:24:41 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2776 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbXB0WYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 17:24:40 -0500
Date: Tue, 27 Feb 2007 22:24:30 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>, Ian Molton <spyro@f2s.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] udivdi3: 64 bit divide
Message-ID: <20070227222430.GC10380@flint.arm.linux.org.uk>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Ian Molton <spyro@f2s.com>,
	Stephen Hemminger <shemminger@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20070226173517.66bf0fec@freekitty> <20070227122437.da27c3cd.akpm@linux-foundation.org> <20070227131840.672d6932@localhost> <20070227133656.c452fbb4.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070227133656.c452fbb4.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 27, 2007 at 01:36:56PM -0800, Andrew Morton wrote:
> On Tue, 27 Feb 2007 13:18:40 -0800 Stephen Hemminger <shemminger@linux-foundation.org> wrote:
> > Then we should pull the existing udivdi3 implementations?
> 
> Not much point really.  Some architectures have gone and done that, but x86
> has not.  x86 has enough coverage for us to pick up most problems, and any
> remaining problems are obviously in scruffy architectures which don't care
> about performance ;)

I doubt arm26 uses udivdi3, but that's something Ian would have to
confirm.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
