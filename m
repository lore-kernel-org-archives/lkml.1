Return-Path: <linux-kernel-owner+w=401wt.eu-S1755762AbYKLQSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762AbYKLQSs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 11:18:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753816AbYKLQNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 11:13:22 -0500
Received: from mx1.suse.de ([195.135.220.2]:59034 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbYKLQNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 11:13:21 -0500
Date: Wed, 12 Nov 2008 08:10:09 -0800
From: Greg KH <gregkh@suse.de>
To: Neil Armstrong <narmstrong@neotion.com>
Cc: "Hans J. Koch" <hjk@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uio: add ioctl callback
Message-ID: <20081112161009.GA6272@suse.de>
References: <491AF8D1.4060106@neotion.com> <20081112154919.GC2891@local> <491AFD7C.8090607@neotion.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491AFD7C.8090607@neotion.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2008 at 04:59:56PM +0100, Neil Armstrong wrote:
> Hi Hans,
> 
> We need an ioctl callback because we need to query some values only
> available when the irq handler is running.
> For example, we have 3 types of reasons why the irq is triggered and
> these bits are no more available when the irq is cleared.
> 
> The cleanest way to have this very specific information is to have a
> dirty old ioctl returning this data.

Do you also have a patch for your UIO driver that implements this
functionality?

I really don't think we want to add an ioctl callback, perhaps you could
just use a sysfs file for this?

thanks,

greg k-h
