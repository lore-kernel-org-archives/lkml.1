Return-Path: <linux-kernel-owner+w=401wt.eu-S1757935AbYB0Ubp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935AbYB0Ubp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 15:31:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757297AbYB0Ubg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 15:31:36 -0500
Received: from www.tglx.de ([62.245.132.106]:35361 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757616AbYB0Ubf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 15:31:35 -0500
Date: Wed, 27 Feb 2008 21:31:07 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Quel Qun <kelk1@comcast.net>
cc: David Miller <davem@davemloft.net>, marcel@holtmann.org,
       dwmw2@infradead.org, hidave.darkstar@gmail.com,
       linux-kernel@vger.kernel.org, jkosina@suse.cz, mingo@elte.hu
Subject: Re: [PATCH] bluetooth: delete timer in l2cap_conn_del()
In-Reply-To: <022720082021.26121.47C5C66700041AAD000066092200751090CE05040A05@comcast.net>
Message-ID: <alpine.LFD.1.00.0802272125470.7583@apollo.tec.linutronix.de>
References: <022720082021.26121.47C5C66700041AAD000066092200751090CE05040A05@comcast.net>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008, Quel Qun wrote:
> > > > I'll apply this, thanks Thomas.
> > > 
> > > can you please wait for a confirmation from Quel that this fixes it.  
> > > My ACK is based on that he confirms that it fixes it for sure.
> > 
> > It doesn't hurt to toss this to Linus now, if it's bogus we
> > have tons of time to revert it.
>
> As I said, it prevents the crash, but does not 'fix' my problem, in
> that I still cannot use the dongle.

The disfunctionality of your dongle is a separate problem and I hope
that the bluetooth wizards will help you to get this sucker running.

The timer which is not deactivated before the data structure
containing it is a simple bug, which needs to be addressed ASAP.

Thanks again for your patience in tracking this down,

	tglx
