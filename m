Return-Path: <linux-kernel-owner+w=401wt.eu-S965679AbXC1S7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965679AbXC1S7o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 14:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965680AbXC1S7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 14:59:44 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56952
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S965679AbXC1S7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 14:59:43 -0400
Date: Wed, 28 Mar 2007 11:59:43 -0700 (PDT)
Message-Id: <20070328.115943.03111877.davem@davemloft.net>
To: jkosina@suse.cz
Cc: akpm@linux-foundation.org, acme@mandriva.com, jagger@swiecki.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] DCCP: proper optlen checking in do_dccp_getsockopt()
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0703282045010.19566@jikos.suse.cz>
References: <Pine.LNX.4.64.0703282045010.19566@jikos.suse.cz>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>
Date: Wed, 28 Mar 2007 20:49:32 +0200 (CEST)

> From: Jiri Kosina <jkosina@suse.cz>
> 
> DCCP: proper optlen checking in do_dccp_getsockopt()
> 
> Robert Swiecki discovered [1] a signedness bug in checking of
> optlen in do_dccp_getsockopt(). This bug can allow user to
> read parts of the kernel memory.
> 
> [1] http://www.securityfocus.com/archive/1/463934/30/0/threaded

Arnaldo already sent me a more proper fix for this.
