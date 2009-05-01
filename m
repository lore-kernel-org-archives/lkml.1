Return-Path: <linux-kernel-owner+w=401wt.eu-S1761756AbZEAPk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761756AbZEAPk6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 11:40:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754281AbZEAPkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 11:40:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49536 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752399AbZEAPkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 11:40:49 -0400
Date: Fri, 1 May 2009 08:14:35 -0700
From: Greg KH <gregkh@suse.de>
To: Jean Delvare <khali@linux-fr.org>
Cc: Ming Lei <tom.leiming@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] driver core: Silent meaningless error message
Message-ID: <20090501151435.GB16106@suse.de>
References: <20090501145151.5f97456e@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090501145151.5f97456e@hyperion.delvare>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 02:51:51PM +0200, Jean Delvare wrote:
> I see the following error message in my kernel logs:
> 
> w83627ehf.2576: use which platform_data?
> 
> This is caused by platform_device_add_data() setting both
> pdev->platform_data and pdev->dev.platform_data, and then
> platform_device_add() complaining if both pointers are set.
> 

The patch that causes this is about to be reverted later today (it's
already reverted in my trees), as it was the wrong thing to do, as you
point out.

So this should be solved soon, no need for your patch.

thanks,

greg k-h
