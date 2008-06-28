Return-Path: <linux-kernel-owner+w=401wt.eu-S1752976AbYF1CwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbYF1CwK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 22:52:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbYF1Cvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 22:51:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39397
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751932AbYF1Cvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 22:51:50 -0400
Date: Fri, 27 Jun 2008 19:51:50 -0700 (PDT)
Message-Id: <20080627.195150.131371077.davem@davemloft.net>
To: xiyou.wangcong@gmail.com
Cc: wcong@critical-links.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, kuznet@ms2.inr.ac.ru
Subject: Re: [Patch] net/sched/sch_generic.c: fix an error pointer
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080621195526.GA25715@hack.netcabo.pt>
References: <20080619153714.5614d5be@hack>
	<20080619.161108.23678497.davem@davemloft.net>
	<20080621195526.GA25715@hack.netcabo.pt>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: WANG Cong <xiyou.wangcong@gmail.com>
Date: Sat, 21 Jun 2008 20:55:26 +0100

> ERR_PTR() ususally encodes an negative errno, not positive.
> 
> Note, in the following patch, 'err' is initialized as:
> 
> int err = -ENOBUFS;
> 
> Signed-off-by: WANG Cong <wcong@critical-links.com>

Patch applied, th anks.
