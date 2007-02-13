Return-Path: <linux-kernel-owner+w=401wt.eu-S1751466AbXBMSWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466AbXBMSWI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 13:22:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbXBMSWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 13:22:08 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46366 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbXBMSWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 13:22:07 -0500
Date: Tue, 13 Feb 2007 18:22:01 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: Rodolfo Giometti <giometti@enneenne.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pxafb: Add option to enable/disable the cursor
In-Reply-To: <20070213180456.GL8882@enneenne.com>
Message-ID: <Pine.LNX.4.64.0702131821020.6679@pentafluge.infradead.org>
References: <20070213173805.GK8882@enneenne.com> <20070213174829.GA465@flint.arm.linux.org.uk>
 <20070213180456.GL8882@enneenne.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> On Tue, Feb 13, 2007 at 05:48:29PM +0000, Russell King wrote:
> > 
> > Maybe this should be a generic option?  Or maybe issue ESC [ 25 l
> > to disable the cursor if you're wanting to turn it off from userspace.
> 
> This is useful if you have a full screen boot logo. How I can issue
> ESC [ 25 l at boot time?
> 
> Without this patch the full screen boot logo is corrupted in the upper
> left corner with a little box containing the blinking cursor.

The reason you have a cursor is because you are using the framebuffer 
console. Do you need fbcon ? 
