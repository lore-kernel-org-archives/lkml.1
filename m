Return-Path: <linux-kernel-owner+w=401wt.eu-S1755035AbZDTJJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035AbZDTJJg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 05:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754918AbZDTJIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 05:08:43 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59078
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754886AbZDTJIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 05:08:42 -0400
Date: Mon, 20 Apr 2009 02:08:34 -0700 (PDT)
Message-Id: <20090420.020834.105105859.davem@davemloft.net>
To: divy@chelsio.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 2.6.30 4/4] cxgb3: Fix EEH final recovery attempt
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090417222127.8569.59426.stgit@speedy5>
References: <20090417222127.8569.59426.stgit@speedy5>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>
Date: Fri, 17 Apr 2009 15:21:27 -0700

> EEH attempts to recover up 6 times.
> The last attempt leaves all the ports and adapter down.hen
> The driver is then unloaded, bringing the adapter down again
> unconditionally. The unload will hang.
> Check if the adapter is already down before trying to bring it down again.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>

Applied.
