Return-Path: <linux-kernel-owner+w=401wt.eu-S1751010AbXDKHo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751010AbXDKHo3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 03:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751006AbXDKHo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 03:44:29 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3769 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbXDKHo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 03:44:27 -0400
Date: Wed, 11 Apr 2007 08:44:15 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] markers-linker-generic
Message-ID: <20070411074414.GC3752@flint.arm.linux.org.uk>
Mail-Followup-To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20070410223658.GC7092@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070410223658.GC7092@Krystal>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2007 at 06:36:58PM -0400, Mathieu Desnoyers wrote:
> Defines the linker marcro EXTRA_RWDATA for marker data section. It
> puts the marker data in a separate section that will not pollute the
> normal .data section, which minimize the cache impact. Markers need such
> a special section because they define a lot of spreaded and small data
> structures at multiple sites.
> 
> This patch also creates the __markers_strings section (ro marker
> strings) and makes sure the __markers section is aligned by putting it
> before the __ksymtab_strings (not after).

What's this marker stuff about?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
