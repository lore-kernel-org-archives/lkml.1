Return-Path: <linux-kernel-owner+w=401wt.eu-S1759175AbZCMV0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759175AbZCMV0t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 17:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754433AbZCMV0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 17:26:40 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52137
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751903AbZCMV0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 17:26:40 -0400
Date: Fri, 13 Mar 2009 14:26:26 -0700 (PDT)
Message-Id: <20090313.142626.59387316.davem@davemloft.net>
To: scott@canonical.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/31] netlink: Auto-load af_netlink module when socket
 opened.
From: David Miller <davem@davemloft.net>
In-Reply-To: <c6919858453711fcfb8202da07b54dae483592c7.1236702228.git.scott@canonical.com>
References: <cover.1236702228.git.scott@canonical.com>
	<c6919858453711fcfb8202da07b54dae483592c7.1236702228.git.scott@canonical.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Scott James Remnant <scott@canonical.com>
Date: Mon, 2 Mar 2009 16:44:00 +0000

> The af_netlink module is missing the net-pf-16 alias that would cause it
> to be auto-loaded when a socket of that type is opened.  This patch adds
> the alias.
> 
> While we normally build this module in, some users may choose to
> reconfigure their kernel with this as a module.
> 
> Signed-off-by: Scott James Remnant <scott@canonical.com>
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>

If you can get netlink to be built modular, impressive. :-)

It's always built statically into the kernel so there is no
reason for this patch.
