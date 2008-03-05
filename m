Return-Path: <linux-kernel-owner+w=401wt.eu-S1761135AbYCEV35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761135AbYCEV35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 16:29:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756137AbYCEV3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 16:29:46 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46544
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754381AbYCEV3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 16:29:46 -0500
Date: Wed, 05 Mar 2008 13:29:44 -0800 (PST)
Message-Id: <20080305.132944.68665776.davem@davemloft.net>
To: paulmck@linux.vnet.ibm.com
Cc: xemul@openvz.org, akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, ebiederm@xmission.com,
       adobriyan@openvz.org
Subject: Re: [PATCH] Make /proc/net a symlink on /proc/self/net
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080305191501.GF8728@linux.vnet.ibm.com>
References: <47CE8FF7.7000701@openvz.org>
	<20080305191501.GF8728@linux.vnet.ibm.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Wed, 5 Mar 2008 11:15:01 -0800

> One question below for get_proc_task_net() -- I don't see how the
> reference to a task struct is released.

Yes, it definitely seems to leak.
