Return-Path: <linux-kernel-owner+w=401wt.eu-S937525AbYEBXVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937525AbYEBXVm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 19:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937461AbYEBXVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 19:21:20 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36092
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S937453AbYEBXVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 19:21:18 -0400
Date: Fri, 02 May 2008 16:21:18 -0700 (PDT)
Message-Id: <20080502.162118.113930840.davem@davemloft.net>
To: arjan@infradead.org
Cc: netdev@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Add a WARN_ON_ONCE() to the transmit timeout
 function
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080501133424.678be79a@infradead.org>
References: <20080501133424.678be79a@infradead.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@infradead.org>
Date: Thu, 1 May 2008 13:34:24 -0700

> WARN_ON_ONCE() gives a stack trace including the full module list.
> Having this in the kernel dump for the timeout case in the
> generic netdev watchdog will help us see quicker which driver
> is involved. It also allows us to collect statistics 
> and patterns in terms of which drivers have this event occuring.
> 
> Suggested by Andrew Morton
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

Looks good, applied.
