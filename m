Return-Path: <linux-kernel-owner+w=401wt.eu-S1751246AbXA2MBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751246AbXA2MBH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 07:01:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbXA2MBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 07:01:06 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbXA2MBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 07:01:05 -0500
Date: Mon, 29 Jan 2007 07:01:00 -0500
From: Alan Cox <alan@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: alan@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: cleanup release_mem
Message-ID: <20070129120100.GA4338@devserv.devel.redhat.com>
References: <20070128171244.GA21378@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070128171244.GA21378@lst.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 28, 2007 at 06:12:44PM +0100, Christoph Hellwig wrote:
> release_mem contains two copies of exactly the same code.  Refactor
> these into a new helper, release_tty.  The only change in behaviour
> is that the driver reference count is now decremented after the
> master tty has been freed instead of before.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Alan Cox <alan@redhat.com>

Please propogate the mutex_ FIXME comment to both functions as it may
well need to cover tty->link

