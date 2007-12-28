Return-Path: <linux-kernel-owner+w=401wt.eu-S1755183AbXL1AQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183AbXL1AQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 19:16:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754137AbXL1AQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 19:16:05 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37276
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753567AbXL1AQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 19:16:03 -0500
Date: Thu, 27 Dec 2007 16:16:02 -0800 (PST)
Message-Id: <20071227.161602.117475287.davem@davemloft.net>
To: travis@sgi.com
Cc: akpm@linux-foundation.org, clameter@sgi.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, ak@suse.de
Subject: Re: [PATCH 02/10] percpu: Move arch XX_PER_CPU_XX definitions into
 linux/percpu.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071228001047.159448000@sgi.com>
References: <20071228001046.854702000@sgi.com>
	<20071228001047.159448000@sgi.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: travis@sgi.com
Date: Thu, 27 Dec 2007 16:10:48 -0800

> V1->V2:
> - Special consideration for IA64: Add the ability to specify
>   arch specific per cpu flags
> 
> The arch definitions are all the same. So move them into linux/percpu.h.
> 
> We cannot move DECLARE_PER_CPU since some include files just include
> asm/percpu.h to avoid include recursion problems.
> 
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Andi Kleen <ak@suse.de>
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> Signed-off-by: Mike Travis <travis@sgi.com>

Acked-by: David S. Miller <davem@davemloft.net>
