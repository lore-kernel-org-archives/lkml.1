Return-Path: <linux-kernel-owner+w=401wt.eu-S933232AbXEETxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933232AbXEETxA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 15:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933251AbXEETxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 15:53:00 -0400
Received: from www.osadl.org ([213.239.205.134]:51544 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933232AbXEETw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 15:52:59 -0400
Subject: Re: Interrupt-Handling in User Space
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Clifford Wolf <clifford@clifford.at>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20070505191707.GA9300@clifford.at>
References: <20070505191707.GA9300@clifford.at>
Content-Type: text/plain
Date: Sat, 05 May 2007 21:55:33 +0200
Message-Id: <1178394933.31213.22.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-05-05 at 21:17 +0200, Clifford Wolf wrote:
> afaics there is no mechanism in the official kernel tree to handle
> interrupts in user space yet. I'd need that for an embedded project I'm
> woking on atm and are so far not sure if I'm going to implement such a
> generic interface or just write a simple driver that does the job for my
> application. So I'd like to find out what the chances are that such a
> feature will get accepted in the official kernel..

Please take a look at drivers/uio, which is currently in -mm and on the
way to mainline.

	tglx


