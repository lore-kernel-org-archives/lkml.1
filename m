Return-Path: <linux-kernel-owner+w=401wt.eu-S1761564AbZCMRMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761564AbZCMRMV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 13:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761079AbZCMRIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 13:08:17 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47758
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758986AbZCMRIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 13:08:16 -0400
Date: Fri, 13 Mar 2009 10:08:02 -0700 (PDT)
Message-Id: <20090313.100802.67201749.davem@davemloft.net>
To: akineko@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: Network throughput (localhost)
From: David Miller <davem@davemloft.net>
In-Reply-To: <59f1f0cb0903130025k31cc2c9fud865dd776534c2bd@mail.gmail.com>
References: <59f1f0cb0903130025k31cc2c9fud865dd776534c2bd@mail.gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aki Niimura <akineko@gmail.com>
Date: Fri, 13 Mar 2009 00:25:48 -0700

> Any suggestions will be greatly appreciated.

Use AF_UNIX sockets if you want optimal performance.

Solaris treats TCP connections over localhost specially,
and we have no plans to add that optimization any time
soon.
