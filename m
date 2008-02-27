Return-Path: <linux-kernel-owner+w=401wt.eu-S1757906AbYB0TIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906AbYB0TIR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 14:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756307AbYB0TIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 14:08:06 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55223
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756167AbYB0TIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 14:08:05 -0500
Date: Wed, 27 Feb 2008 11:07:49 -0800 (PST)
Message-Id: <20080227.110749.136686913.davem@davemloft.net>
To: marcel@holtmann.org
Cc: tglx@linutronix.de, kelk1@comcast.net, dwmw2@infradead.org,
       hidave.darkstar@gmail.com, linux-kernel@vger.kernel.org,
       jkosina@suse.cz, mingo@elte.hu
Subject: Re: [PATCH] bluetooth: delete timer in l2cap_conn_del()
From: David Miller <davem@davemloft.net>
In-Reply-To: <C1D6688B-49F8-4ED1-B4F6-07F21243237F@holtmann.org>
References: <alpine.LFD.1.00.0802260926550.7583@apollo.tec.linutronix.de>
	<20080226.174315.112638342.davem@davemloft.net>
	<C1D6688B-49F8-4ED1-B4F6-07F21243237F@holtmann.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcel Holtmann <marcel@holtmann.org>
Date: Wed, 27 Feb 2008 10:55:07 +0100

> Hi Dave,
> 
> > From: Thomas Gleixner <tglx@linutronix.de>
> > Date: Tue, 26 Feb 2008 09:28:13 +0100 (CET)
> >
> >> Delete a possibly armed timer before kfree'ing the connection object.
> >>
> >> Solves: http://lkml.org/lkml/2008/2/15/514
> >>
> >> Reported-by:Quel Qun <kelk1@comcast.net>
> >> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> >
> > I'll apply this, thanks Thomas.
> 
> can you please wait for a confirmation from Quel that this fixes it.  
> My ACK is based on that he confirms that it fixes it for sure.

It doesn't hurt to toss this to Linus now, if it's bogus we
have tons of time to revert it.
