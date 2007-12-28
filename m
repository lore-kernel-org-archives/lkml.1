Return-Path: <linux-kernel-owner+w=401wt.eu-S1754895AbXL1AP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbXL1AP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 19:15:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754113AbXL1APV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 19:15:21 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37270
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753911AbXL1APU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 19:15:20 -0500
Date: Thu, 27 Dec 2007 16:15:19 -0800 (PST)
Message-Id: <20071227.161519.78953090.davem@davemloft.net>
To: travis@sgi.com
Cc: akpm@linux-foundation.org, clameter@sgi.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, ak@suse.de
Subject: Re: [PATCH 01/10] percpu: Use a kconfig variable to signal arch
 specific percpu setup
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071228001047.036858000@sgi.com>
References: <20071228001046.854702000@sgi.com>
	<20071228001047.036858000@sgi.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: travis@sgi.com
Date: Thu, 27 Dec 2007 16:10:47 -0800

> V1->V2:
> - Use def_bool as suggested by Randy.
> 
> The use of the __GENERIC_PERCPU is a bit problematic since arches
> may want to run their own percpu setup while using the generic
> percpu definitions. Replace it through a kconfig variable.
> 
> 
> 
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Andi Kleen <ak@suse.de>
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> Signed-off-by: Mike Travis <travis@sgi.com>

Acked-by: David S. Miller <davem@davemloft.net>
