Return-Path: <linux-kernel-owner+w=401wt.eu-S1753365AbYIKJf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbYIKJf1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 05:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751905AbYIKJfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 05:35:15 -0400
Received: from relay2.sgi.com ([192.48.171.30]:51523 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751876AbYIKJfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 05:35:14 -0400
Date: Thu, 11 Sep 2008 04:35:08 -0500
From: Robin Holt <holt@sgi.com>
To: Alessio Sangalli <alesan@manoweb.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 8MB physical memory allocation
Message-ID: <20080911093508.GD23082@sgi.com>
References: <48C89ECD.6050900@manoweb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C89ECD.6050900@manoweb.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 09:30:05PM -0700, Alessio Sangalli wrote:
> Hi, I'm writing a driver for a video adapter that needs to allocate 8MB
> (maximum resolution) in physical, contiguos memory. I am working on a
> ARM9 platform.

Not sure about arm9, but on ia64, alloc_pages does the trick.

	alloc_pages(GFP_KERNEL, 33-PAGE_SHIFT);

Might be slightly large of an allocation for any time other than boot,
but that is the call.

Thanks,
Robin
