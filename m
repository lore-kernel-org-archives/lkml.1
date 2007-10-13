Return-Path: <linux-kernel-owner+w=401wt.eu-S1762548AbXJMUfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762548AbXJMUfg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 16:35:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756939AbXJMUf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 16:35:27 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:60426 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756659AbXJMUf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 16:35:27 -0400
Date: Sat, 13 Oct 2007 22:35:25 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: David <david@unsolicited.net>
cc: Peter Volkov <pva@gentoo.org>, linux-kernel@vger.kernel.org
Subject: Re: regression(?): starting with 2.6.21 sending packets became
 broken.
In-Reply-To: <4711159D.1010305@unsolicited.net>
Message-ID: <Pine.LNX.4.64.0710132233000.3348@fbirervta.pbzchgretzou.qr>
References: <1192299385.31908.8.camel@localhost> <4711159D.1010305@unsolicited.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 13 2007 19:59, David wrote:
>Try
>
>echo 0 > /proc/sys/net/ipv4/tcp_window_scaling
>
>I bet you have broken router(s) between your machine and the problem
>site(s).

There is an xt_TCPOPTSTRIP module in the works that allows you to strip
Window Scaling only on the connections you want (rather than globally);
seems to be in for 2.6.24 at earliest, though it's there is also the 
standalone patch.
