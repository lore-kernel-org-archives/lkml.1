Return-Path: <linux-kernel-owner+w=401wt.eu-S1762122AbYCAGZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762122AbYCAGZl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 01:25:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761533AbYCAGZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 01:25:10 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:50820 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756357AbYCAGZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 01:25:09 -0500
Date: Fri, 29 Feb 2008 22:02:36 -0800
From: Greg KH <greg@kroah.com>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86 pci: remove checking type for mmconfig probe v2
Message-ID: <20080301060236.GE20032@kroah.com>
References: <200802271639.52958.yinghai.lu@sun.com> <200802282356.50496.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802282356.50496.yinghai.lu@sun.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 11:56:50PM -0800, Yinghai Lu wrote:
> 
> doesn't need to check if it is type1 or type2. we can use raw_pci_ops dirctly.

Why?  is this because the ops are already set up?  It would be nice to
add the "why this change is necessary and/or possible now" for the
changelog.

thanks,

greg k-h
