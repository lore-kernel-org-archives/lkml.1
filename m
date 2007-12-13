Return-Path: <linux-kernel-owner+w=401wt.eu-S1762739AbXLMReT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762739AbXLMReT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 12:34:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759856AbXLMReK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 12:34:10 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36237
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759804AbXLMReI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 12:34:08 -0500
Date: Thu, 13 Dec 2007 09:34:07 -0800 (PST)
Message-Id: <20071213.093407.42002244.davem@davemloft.net>
To: tcallawa@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix compiler warning noise with FORE200E driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1197562900.17945.16.camel@localhost.localdomain>
References: <1197562900.17945.16.camel@localhost.localdomain>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Tom \"spot\" Callaway" <tcallawa@redhat.com>
Date: Thu, 13 Dec 2007 11:21:40 -0500

> gcc throws these warnings with:
> 
> CONFIG_ATM_FORE200E=m
> # CONFIG_ATM_FORE200E_PCA is not set
> 
> drivers/atm/fore200e.c:2695: warning: 'fore200e_pca_detect' defined but
> not used
> drivers/atm/fore200e.c:2748: warning: 'fore200e_pca_remove_one' defined
> but not used
> 
> By moving the #ifdef CONFIG_ATM_FORE200E_PCA around those two functions,
> the compiler warnings are silenced.
> 
> (btw, I'm not subscribed to lkml, so please CC me on any responses,
> although this is a wholly trivial patch, so I'm not expecting any.)
> 
> Signed-off-by: Tom "spot" Callaway <tcallawa@redhat.com>

Applied, thanks Tom.

