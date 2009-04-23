Return-Path: <linux-kernel-owner+w=401wt.eu-S1756831AbZDWNdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831AbZDWNdu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 09:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754631AbZDWNdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 09:33:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56524
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753005AbZDWNdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 09:33:41 -0400
Date: Thu, 23 Apr 2009 06:33:32 -0700 (PDT)
Message-Id: <20090423.063332.154679155.davem@davemloft.net>
To: tj@kernel.org
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, joerg@dorchain.net,
       geert@linux-m68k.org, donari75@gmail.com, jdike@linux.intel.com,
       benh@kernel.crashing.org, Laurent@lvivier.info
Subject: Re: [PATCH 05/12] sunvdc: kill vdc_end_request()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1240489553-15724-6-git-send-email-tj@kernel.org>
References: <1240489553-15724-1-git-send-email-tj@kernel.org>
	<1240489553-15724-6-git-send-email-tj@kernel.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Thu, 23 Apr 2009 21:25:46 +0900

> vdc_end_request() is a thin silly wrapper on top of
> __blk_end_request().  Kill it.
> 
> [ Impact: cleanup ]
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: David S. Miller <davem@davemloft.net>
