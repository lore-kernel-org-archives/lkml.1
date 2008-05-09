Return-Path: <linux-kernel-owner+w=401wt.eu-S1759865AbYEIWpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759865AbYEIWpz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 18:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754776AbYEIWpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 18:45:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37469
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752949AbYEIWpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 18:45:44 -0400
Date: Fri, 09 May 2008 15:45:38 -0700 (PDT)
Message-Id: <20080509.154538.28321777.davem@davemloft.net>
To: Matheos.Worku@Sun.COM
Cc: jesper@krogh.cc, yhlu.kernel@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: NIU - Sun Neptune 10g - Transmit timed out reset (2.6.24)
From: David Miller <davem@davemloft.net>
In-Reply-To: <4824D1E1.10007@sun.com>
References: <4824CBA1.8040703@sun.com>
	<4824CCF0.5050302@krogh.cc>
	<4824D1E1.10007@sun.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matheos Worku <Matheos.Worku@Sun.COM>
Date: Fri, 09 May 2008 15:36:17 -0700

> I have observed TX throughput degradation (and increased CPU 
> utilization)  occurs with increased # of connections, when CPU count > 4 
> CPUs.  I don't think it is related to the driver (or HW).

All transmits through a device are fully serialized currently,
it's a known problem and something we plan to fix.
