Return-Path: <linux-kernel-owner+w=401wt.eu-S1751363AbXBMRsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751363AbXBMRsh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 12:48:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbXBMRsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 12:48:37 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3724 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbXBMRsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 12:48:37 -0500
Date: Tue, 13 Feb 2007 17:48:29 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pxafb: Add option to enable/disable the cursor
Message-ID: <20070213174829.GA465@flint.arm.linux.org.uk>
Mail-Followup-To: Rodolfo Giometti <giometti@enneenne.com>,
	linux-kernel@vger.kernel.org
References: <20070213173805.GK8882@enneenne.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070213173805.GK8882@enneenne.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 13, 2007 at 06:38:05PM +0100, Rodolfo Giometti wrote:
> Add cursor enable/disable, very useful if you wish a full screen boot
> logo.

Maybe this should be a generic option?  Or maybe issue ESC [ 25 l
to disable the cursor if you're wanting to turn it off from userspace.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
