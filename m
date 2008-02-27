Return-Path: <linux-kernel-owner+w=401wt.eu-S1755781AbYB0MVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781AbYB0MVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 07:21:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754069AbYB0MVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 07:21:10 -0500
Received: from www.tglx.de ([62.245.132.106]:42315 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754065AbYB0MVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 07:21:09 -0500
Date: Wed, 27 Feb 2008 13:20:17 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Marcel Holtmann <marcel@holtmann.org>
cc: David Miller <davem@davemloft.net>, kelk1@comcast.net, dwmw2@infradead.org,
       hidave.darkstar@gmail.com, linux-kernel@vger.kernel.org,
       jkosina@suse.cz, mingo@elte.hu
Subject: Re: [PATCH] bluetooth: delete timer in l2cap_conn_del()
In-Reply-To: <C1D6688B-49F8-4ED1-B4F6-07F21243237F@holtmann.org>
Message-ID: <alpine.LFD.1.00.0802271319590.7583@apollo.tec.linutronix.de>
References: <022620080003.1247.47C35750000085C8000004DF2207300793CE05040A05@comcast.net> <alpine.LFD.1.00.0802260926550.7583@apollo.tec.linutronix.de> <20080226.174315.112638342.davem@davemloft.net> <C1D6688B-49F8-4ED1-B4F6-07F21243237F@holtmann.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008, Marcel Holtmann wrote:

> Hi Dave,
> 
> > From: Thomas Gleixner <tglx@linutronix.de>
> > Date: Tue, 26 Feb 2008 09:28:13 +0100 (CET)
> > 
> > > Delete a possibly armed timer before kfree'ing the connection object.
> > > 
> > > Solves: http://lkml.org/lkml/2008/2/15/514
> > > 
> > > Reported-by:Quel Qun <kelk1@comcast.net>
> > > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > 
> > I'll apply this, thanks Thomas.
> 
> can you please wait for a confirmation from Quel that this fixes it. My ACK is
> based on that he confirms that it fixes it for sure.

http://lkml.org/lkml/2008/2/25/463

Thanks,

	tglx
