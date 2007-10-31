Return-Path: <linux-kernel-owner+w=401wt.eu-S1755962AbXJaBHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962AbXJaBHK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 21:07:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755258AbXJaBG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 21:06:29 -0400
Received: from gate.crashing.org ([63.228.1.57]:41932 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756219AbXJaBG2 (ORCPT <rfc822;Linux-Kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 21:06:28 -0400
Subject: Re: dev_ifname32() fails on 32->64bit calls in copy_in_user().
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Joel Becker <Joel.Becker@oracle.com>
Cc: Linux Netdev <linux-netdev@vger.kernel.org>,
       Linux Kernel Mailing List <Linux-Kernel@vger.kernel.org>
In-Reply-To: <20071031003850.GE7517@tasint.org>
References: <20071031003850.GE7517@tasint.org>
Content-Type: text/plain
Date: Wed, 31 Oct 2007 12:06:09 +1100
Message-Id: <1193792769.9928.84.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-10-30 at 17:38 -0700, Joel Becker wrote:
> Hello folks,
> 	I've been using a nice program on ppc32 with a ppc64
> system+kernel.  It uses netlink to determine some network interface
> information.  Recent kernels cause it to exit at the netlink stage.  At
> first, I thought it was a bug in the program.  Now I'm not so sure.

 .../...

Reproduced here, I'll have a look, thanks.

Ben.


