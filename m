Return-Path: <linux-kernel-owner+w=401wt.eu-S1756343AbYGRJHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343AbYGRJHm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 05:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754238AbYGRJHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 05:07:32 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:38794 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626AbYGRJHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 05:07:31 -0400
Date: Fri, 18 Jul 2008 11:07:30 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Kumar Gala <galak@kernel.crashing.org>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: use of bool in exported headers?
In-Reply-To: <0FE8A686-5F80-4868-8C85-5E82EA9EF2D1@kernel.crashing.org>
Message-ID: <alpine.LNX.1.10.0807181106200.12734@fbirervta.pbzchgretzou.qr>
References: <0FE8A686-5F80-4868-8C85-5E82EA9EF2D1@kernel.crashing.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2008-07-18 08:28, Kumar Gala wrote:

> What's the rule with regards to use of 'bool' in a header exposed to user space
> apps?
>
> We are getting the following compile error w/iptables because of bool in
> include/linux/netfilter/xt_sctp.h:
>
> In file included from extensions/libip6t_sctp.c:24:

Use #include <stdbool.h> in userspace.
