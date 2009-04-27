Return-Path: <linux-kernel-owner+w=401wt.eu-S1755094AbZD0IJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094AbZD0IJ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 04:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754149AbZD0IJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 04:09:13 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:58065 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682AbZD0IJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 04:09:11 -0400
Date: Mon, 27 Apr 2009 17:03:55 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-sh <linux-sh@vger.kernel.org>
Subject: Re: [PATCH] maple: input: fix up maple mouse driver - v2
Message-ID: <20090427080354.GA26020@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <adrian@newgolddream.info>,
	lkml <linux-kernel@vger.kernel.org>,
	linux-sh <linux-sh@vger.kernel.org>
References: <1240685216.4808.13.camel@localhost.localdomain> <1240692198.4808.21.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240692198.4808.21.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 25, 2009 at 09:43:18PM +0100, Adrian McMenamin wrote:
> On Sat, 2009-04-25 at 19:46 +0100, Adrian McMenamin wrote:
> > The maple mouse driver currently in mainline is broken:
> 
> Here is a better fix for this, keeping an open and close, so reducing
> the load on the system when the mouse is not in use, and also properly
> referencing the maple device buffer following the recent update.
> 
> drivers/input/mouse/maplemouse.c |   44
> +++++++++++++++++++------------------
>  1 files changed, 23 insertions(+), 21 deletions(-)
> 
> Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>

Applied, thanks.
