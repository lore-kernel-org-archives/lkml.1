Return-Path: <linux-kernel-owner+w=401wt.eu-S1753453AbXFYI2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbXFYI2v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 04:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753295AbXFYI2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 04:28:42 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59677 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbXFYI2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 04:28:41 -0400
Date: Mon, 25 Jun 2007 00:53:09 -0700
From: Greg KH <greg@kroah.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Adrian Bunk <bunk@stusta.de>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>
Subject: Re: [2.6 patch] fix devres_release_all() return value
Message-ID: <20070625075309.GB14203@kroah.com>
References: <20070617234254.GD3588@stusta.de> <46761E52.4020701@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46761E52.4020701@gmail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 02:55:30PM +0900, Tejun Heo wrote:
> Adrian Bunk wrote:
> > Every file should include the headers containing the prototypes for
> > it's global functions.
> > 
> > Since the GNU C compiler is now able to detect that the function 
> > prototype of devres_release_all() in the header and the actual function 
> > disagree regarding the return value, this patch also fixes this bug.
> > 
> > Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 
> Acked-by: Tejun Heo <htejun@gmail.com>
> 
> This should go through Greg.
> 
>   http://article.gmane.org/gmane.linux.kernel/544290/raw

Thanks, I've picked it up now.

greg k-h
