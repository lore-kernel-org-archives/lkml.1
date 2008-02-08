Return-Path: <linux-kernel-owner+w=401wt.eu-S935061AbYBHSLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935061AbYBHSLv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 13:11:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759908AbYBHSLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 13:11:41 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:54711 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758914AbYBHSLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 13:11:40 -0500
Date: Fri, 8 Feb 2008 10:09:29 -0800
From: Greg KH <greg@kroah.com>
To: Oliver Pinter <oliver.pntr@gmail.com>
Cc: torvalds@linux-foundation.org, Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, cliph@research.coseinc.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] splice: missing user pointer access verification
	(CVE-2008-0009/10)
Message-ID: <20080208180929.GA18905@kroah.com>
References: <0802051044200.29525@mjc.redhat.com> <20080205165301.1e0b8ad8.akpm@linux-foundation.org> <20080206095510.GA15220@kernel.dk> <20080207223146.GI19310@kroah.com> <20080208160203.GB23197@kernel.dk> <20080208164914.GB17072@kroah.com> <6101e8c40802080948x9e425ar28842a78801e9a35@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6101e8c40802080948x9e425ar28842a78801e9a35@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 06:48:54PM +0100, Oliver Pinter wrote:
> greg it's for .22 or the splice is changed between .22 and .23?

splice changed for .23 and this only affects .23 and older kernels, so
.22 and older kernels do not have issues.

thanks,

greg k-h
