Return-Path: <linux-kernel-owner+w=401wt.eu-S1759637AbYARCbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759637AbYARCbY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 21:31:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756877AbYARCbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 21:31:13 -0500
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:53062 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756845AbYARCbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 21:31:11 -0500
Date: Thu, 17 Jan 2008 21:31:10 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>, akpm@linux-foundation.org,
       airlied@linux.ie, linux-kernel@vger.kernel.org
Subject: Re: [mm patch] i915: fix invalid opcode exception on cpus without
	clflush
Message-ID: <20080118023110.GA31386@phobos.i.cabal.ca>
References: <20080117235203.GB21681@phobos.i.cabal.ca> <479008E5.1070706@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479008E5.1070706@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2008 at 09:03:17PM -0500, H. Peter Anvin wrote:
> The #ifdef is bogus.  If it's required, it should go into 
> asm-x86/required_features.h and then cpu_has_clflush is static; otherwise 
> it's just plain wrong.
>

I have no objection to making cpu_has_clflush constant on x86_64. The
point was to get rid of a needless test & branch on 64-bit, and making
it constant will have the same effect.

cheers, Kyle
