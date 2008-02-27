Return-Path: <linux-kernel-owner+w=401wt.eu-S932190AbYB0Bmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190AbYB0Bmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 20:42:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753630AbYB0Bma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 20:42:30 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56691
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752884AbYB0Bma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 20:42:30 -0500
Date: Tue, 26 Feb 2008 17:43:15 -0800 (PST)
Message-Id: <20080226.174315.112638342.davem@davemloft.net>
To: tglx@linutronix.de
Cc: kelk1@comcast.net, dwmw2@infradead.org, hidave.darkstar@gmail.com,
       marcel@holtmann.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
       mingo@elte.hu
Subject: Re: [PATCH] bluetooth: delete timer in l2cap_conn_del()
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.00.0802260926550.7583@apollo.tec.linutronix.de>
References: <022620080003.1247.47C35750000085C8000004DF2207300793CE05040A05@comcast.net>
	<alpine.LFD.1.00.0802260926550.7583@apollo.tec.linutronix.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 26 Feb 2008 09:28:13 +0100 (CET)

> Delete a possibly armed timer before kfree'ing the connection object.
> 
> Solves: http://lkml.org/lkml/2008/2/15/514
> 
> Reported-by:Quel Qun <kelk1@comcast.net>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

I'll apply this, thanks Thomas.
