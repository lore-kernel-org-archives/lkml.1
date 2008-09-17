Return-Path: <linux-kernel-owner+w=401wt.eu-S1755834AbYIQVx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834AbYIQVx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 17:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753442AbYIQVxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 17:53:49 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:43978 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164AbYIQVxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 17:53:48 -0400
Message-ID: <48D17C69.6060203@garzik.org>
Date: Wed, 17 Sep 2008 17:53:45 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       torvalds@linux-foundation.org, davem@davemloft.net
Subject: Re: warn: Turn the netdev timeout WARN_ON() into a WARN()
References: <200809170259.m8H2xClI020907@hera.kernel.org>	<20080917032708.GA8431@havoc.gtf.org>	<20080917064128.2b2f8616@linux.intel.com>	<48D178FB.80902@garzik.org> <20080917144558.6ed2e6b8@linux.intel.com>
In-Reply-To: <20080917144558.6ed2e6b8@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> I cannot disagree with the "the backtrace is not useful" statement for
> this case. I don't even mind making a WARN() variant that doesn't
> backtrace; I'll look into that. I don't consider it "2.6.27 urgent"
> though; a backtrace is pretty light to do for such an exceptional
> slowpath case, and the only real effect is a few lines
> in /var/log/messages that are somewhat redundant.


Quite agreed -- I never meant to imply that [second half of my reply] 
was urgent, just giving some food for thought about improving the system.

	Jeff


