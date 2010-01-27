Return-Path: <linux-kernel-owner+w=401wt.eu-S1755496Ab0A0Azh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab0A0Azh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 19:55:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755409Ab0A0Aze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 19:55:34 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:57878 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815Ab0A0AzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 19:55:25 -0500
Date: Tue, 26 Jan 2010 19:55:10 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: which fields in /proc/meminfo are orthogonal?
Message-ID: <20100127005510.GA8637@c2.user-mode-linux.org>
References: <4B5F3C9C.3050908@nortel.com> <4B5F54DE.7030302@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B5F54DE.7030302@nortel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 02:47:26PM -0600, Chris Friesen wrote:
> I've tried adding up
> MemFree+Buffers+Cached+AnonPages+Mapped+Slab+PageTables+VmallocUsed
> 
> (hugepages are disabled and there is no swap)
> 
> Shortly after boot this gets me within about 3MB of MemTotal.  However,
> after 1070 minutes there is a 64MB difference between MemTotal and the
> above sum.

I believe that pages allocated directly with get_free_pages won't show
up in your sum.  So, just look for someone doing a lot of that :-)

				Jeff
