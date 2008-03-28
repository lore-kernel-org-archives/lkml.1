Return-Path: <linux-kernel-owner+w=401wt.eu-S1756366AbYC1AFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366AbYC1AFL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 20:05:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753716AbYC1AEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 20:04:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36728
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753625AbYC1AEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 20:04:54 -0400
Date: Thu, 27 Mar 2008 17:04:54 -0700 (PDT)
Message-Id: <20080327.170454.124353224.davem@davemloft.net>
To: joe@perches.com
Cc: ilpo.jarvinen@helsinki.fi, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, acme@redhat.com,
       mpm@selenic.com
Subject: Re: [PATCH 1/7] [NET]: uninline skb_put, de-bloats a lot
From: David Miller <davem@davemloft.net>
In-Reply-To: <1206662557.4849.112.camel@localhost>
References: <1206645050.4849.77.camel@localhost>
	<20080327.150456.39560267.davem@davemloft.net>
	<1206662557.4849.112.camel@localhost>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Thu, 27 Mar 2008 17:02:37 -0700

> I think this is the sort of change you might have argued
> against accepting without performance testing not long ago.

Look at how complicated the assembler of this function
is.  Any inlining performance gains will be trumped by
the instruction cache usage bloat.
