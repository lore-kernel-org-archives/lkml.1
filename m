Return-Path: <linux-kernel-owner+w=401wt.eu-S1760078AbYEWWse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760078AbYEWWse (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 18:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753510AbYEWWs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 18:48:27 -0400
Received: from gate.crashing.org ([63.228.1.57]:47734 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753752AbYEWWs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 18:48:26 -0400
Subject: Re: MMIO and gcc re-ordering (Was: [PATCH] [POWERPC]
	Improve	(in|out)_beXX() asm code)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Scott Wood <scottwood@freescale.com>
Cc: Trent Piepho <tpiepho@freescale.com>, David Miller <davem@davemloft.net>,
       linuxppc-dev@ozlabs.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <4837339F.9060407@freescale.com>
References: <4833524C.3040207@freescale.com>
	 <20080520.153947.84346222.davem@davemloft.net>
	 <4833542E.3040608@freescale.com>
	 <20080520.155326.195407196.davem@davemloft.net>
	 <1211516683.8297.271.camel@pasglop>
	 <Pine.LNX.4.64.0805221553400.8205@t2.domain.actdsltmp>
	 <1211546197.8297.308.camel@pasglop> <1211547016.8297.310.camel@pasglop>
	 <4837339F.9060407@freescale.com>
Content-Type: text/plain
Date: Fri, 23 May 2008 18:47:32 -0400
Message-Id: <1211582852.8297.347.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-05-23 at 16:14 -0500, Scott Wood wrote:

> As Trent pointed out, if you change to eieio in the accessors, that'd 
> require drivers to also use mmiowb() before spin_unlock(), which fewer 
> drivers currently do.

No, this is a totally different issue. And we keep track of the need
for a sync in spin_unlock already.

Ben.


