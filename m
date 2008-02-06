Return-Path: <linux-kernel-owner+w=401wt.eu-S934548AbYBGAfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934548AbYBGAfl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:35:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764919AbYBGADA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 19:03:00 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:40657 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759419AbYBGAC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 19:02:58 -0500
Date: Wed, 6 Feb 2008 15:59:40 -0800
From: Greg KH <greg@kroah.com>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: Paul Mundt <lethal@users.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-sh <linux-sh@vger.kernel.org>
Subject: Re: [PATCH 2/2] - SH/Dreamcast - fix maple bus bugs
Message-ID: <20080206235940.GA16116@kroah.com>
References: <1202337981.6162.8.camel@localhost.localdomain> <1202338431.6162.15.camel@localhost.localdomain> <20080206230127.GA9614@kroah.com> <1202339114.6162.17.camel@localhost.localdomain> <20080206232349.GA15654@kroah.com> <1202341881.6162.22.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202341881.6162.22.camel@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2008 at 11:51:21PM +0000, Adrian McMenamin wrote:
> Replacement second-in-series patch:
> 
> This patch fixes up memory leaks and, by delaying initialisation, makes
> device detection more robust.
> 
> It also makes clearer the difference between struct maple_device and
> struct device, as well as cleaning up the interrupt request code
> (without changing its function in any way).
> 
> Also now removes redundant registration checking.

Thanks for changing this.

greg k-h
