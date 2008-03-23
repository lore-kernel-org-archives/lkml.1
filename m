Return-Path: <linux-kernel-owner+w=401wt.eu-S1760017AbYCWKLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760017AbYCWKLl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 06:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756094AbYCWKLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 06:11:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45930
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755676AbYCWKL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 06:11:29 -0400
Date: Sun, 23 Mar 2008 03:11:39 -0700 (PDT)
Message-Id: <20080323.031139.17629653.davem@davemloft.net>
To: denys@visp.net.lb
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: kernel panic, ip_route_input, 2.6.25-rc6-git2
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080323073638.M89709@visp.net.lb>
References: <20080323073638.M89709@visp.net.lb>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Denys Fedoryshchenko" <denys@visp.net.lb>
Date: Sun, 23 Mar 2008 09:36:38 +0200

> Recently tested, it crashes also -git6 without lockdep compiled. So it seems 
> actually networking code bug.

I'm still not so sure.

The IP is at ip_route_input but the rest of your backtrace
shows an entirely different code path.

Nothing in the trace matches up, which severely decreases the
usability of the debugging information you've provided.
 
