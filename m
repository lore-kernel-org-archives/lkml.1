Return-Path: <linux-kernel-owner+w=401wt.eu-S1753710AbYJCIfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710AbYJCIfb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 04:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbYJCIfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 04:35:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33612 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbYJCIfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 04:35:23 -0400
Date: Fri, 3 Oct 2008 04:35:22 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
Subject: Re: [RFC/PATCH] Block device for the ISS simulator
Message-ID: <20081003083522.GB25683@infradead.org>
References: <20081003000904.0A812DDEEE@ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081003000904.0A812DDEEE@ozlabs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2008 at 10:08:42AM +1000, Benjamin Herrenschmidt wrote:
> The ISS simulator is a simple powerpc simulator used among other things
> for hardware bringup. It implements a simple memory mapped block device
> interface.
> 
> This is a simple block driver that attaches to it. Note that the choice
> of a major device number is fishy, though because it's a simulator and
> not real hardware, it's not necessarily a big deal.

Please don't put in more block devices for every bloody simulator in the
world.  Just emulated some simpler enough existing hardware.

