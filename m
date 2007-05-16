Return-Path: <linux-kernel-owner+w=401wt.eu-S1762333AbXEPGmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762333AbXEPGmr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 02:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757956AbXEPGmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 02:42:40 -0400
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:45520 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005AbXEPGmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 02:42:40 -0400
Message-ID: <464AA7D7.2040602@kernel.org>
Date: Tue, 15 May 2007 23:42:31 -0700
From: Josh Triplett <josh@kernel.org>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, ak@suse.de, akpm@linux-foundation.org,
       dipankar@in.ibm.com, randy.dunlap@oracle.com
Subject: Re: [PATCH] prohibit rcutorture from being compiled into the kernel
References: <20070516002720.GA22379@linux.vnet.ibm.com>
In-Reply-To: <20070516002720.GA22379@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> There have been a number of instances where people have accidentally
> compiled rcutorture into the kernel (CONFIG_RCU_TORTURE_TEST=y), which
> has never been useful, and has often resulted in great frustration.  The
> attached patch prohibits rcutorture from being compiled into the kernel.
> It may be excluded altogether or compiled as a module.  People wishing
> to have rcutorture hammer their machine immediately upon boot are free
> to hand-edit lib/Kconfig.debug to remove the "depends on m" line.
> 
> Thanks to Randy Dunlap for the trick that makes this work.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

This seems reasonable to me.  I can imagine legitimate reasons to want to
have rcutorture running as early as possible, but as you said, anyone
wishing to do so can hand-edit lib/Kconfig.debug easily enough.

Acked-by: Josh Triplett <josh@kernel.org>

- Josh Triplett

