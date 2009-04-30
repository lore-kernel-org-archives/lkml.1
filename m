Return-Path: <linux-kernel-owner+w=401wt.eu-S1760774AbZD3AVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760774AbZD3AVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 20:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755273AbZD3AVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 20:21:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38064
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752668AbZD3AVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 20:21:08 -0400
Date: Wed, 29 Apr 2009 17:21:00 -0700 (PDT)
Message-Id: <20090429.172100.152526095.davem@davemloft.net>
To: dvomlehn@cisco.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] NETDEV: Wait for autoconfigurable network devices
 to become available
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090430001153.GA3751@cuplxvomd02.corp.sa.net>
References: <20090430001153.GA3751@cuplxvomd02.corp.sa.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This have_all_netdevs() will never return true unless the user
specifies a specific device name.
