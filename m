Return-Path: <linux-kernel-owner+w=401wt.eu-S1754231AbXDPSzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231AbXDPSzu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 14:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754232AbXDPSzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 14:55:50 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38601 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230AbXDPSzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 14:55:49 -0400
Date: Mon, 16 Apr 2007 11:53:33 -0700
From: Greg KH <greg@kroah.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <htejun@gmail.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [Patch -mm 0/3] RFC: module unloading vs. release function
Message-ID: <20070416185333.GA15188@kroah.com>
References: <20070416193619.4659a847@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070416193619.4659a847@gondolin.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2007 at 07:36:19PM +0200, Cornelia Huck wrote:
> Hi,
> 
> based on the discussion in "How should an exit routine wait for
> release() callbacks?"

Wait, why is this needed anymore with the recent work in splitting sysfs
away from the backing code?

thanks,

greg k-h
