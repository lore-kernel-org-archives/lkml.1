Return-Path: <linux-kernel-owner+w=401wt.eu-S1754098AbXKBJsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbXKBJsO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 05:48:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbXKBJsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 05:48:05 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:59552 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852AbXKBJsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 05:48:04 -0400
Date: Fri, 2 Nov 2007 10:47:48 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>, linux-kernel@vger.kernel.org,
       jgarzik@pobox.com
Subject: Re: [PATCH 9/16] CRIS architecture: Correct compile errors
Message-ID: <20071102094748.GE7621@axis.com>
References: <20071030093231.GL11960@axis.com> <47274E93.9030403@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47274E93.9030403@tiscali.nl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2007 at 04:32:35PM +0100, Roel Kluin wrote:
> Jesper Nilsson wrote:
> > +	if (np->mii_if.phy_id == 32)
> >  		 return -ENODEV;
> You need to unlock before this return.

Thanks for spotting this!

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
