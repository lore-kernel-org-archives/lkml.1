Return-Path: <linux-kernel-owner+w=401wt.eu-S1757398AbZA2KdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398AbZA2KdV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 05:33:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbZA2KdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 05:33:11 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40171 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbZA2KdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 05:33:10 -0500
Date: Thu, 29 Jan 2009 10:33:01 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Paul Walmsley <paul@pwsan.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH C 07/13] OMAP3 clock: recalculate DPLL subtree after bypass entry/exit
Message-ID: <20090129103301.GB12627@n2100.arm.linux.org.uk>
References: <20090128190724.12092.22239.stgit@localhost.localdomain> <20090128190826.12092.12778.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090128190826.12092.12778.stgit@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2009 at 12:08:29PM -0700, Paul Walmsley wrote:
> The DPLL's rate changes when it enters or leaves bypass, so the DPLL's
> rate and the rates of all dependent clocks need to be recalculated
> when this happens.
> 
> Also, fix test for bypass to test against the appropriate bypass clock,
> rather than the parent clock (which is not the bypass clock for DPLL1
> and DPLL2).

Surely this is a bug fix to the previous patch?
