Return-Path: <linux-kernel-owner+w=401wt.eu-S1752863AbYAEFBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbYAEFBj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 00:01:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750889AbYAEFBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 00:01:30 -0500
Received: from mo11.iij4u.or.jp ([210.138.174.79]:60334 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766AbYAEFB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 00:01:29 -0500
Message-Id: <200801050501.m0551LFB030667@mbox.iij4u.or.jp>
To: deepakrc@gmail.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH] bsg : Add support for io vectors in bsg
From: FUJITA Tomonori <tomof@acm.org>
In-Reply-To: <Pine.LNX.4.64.0801042137350.7836@localhost>
References: <Pine.LNX.4.64.0801042137350.7836@localhost>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Date: Sat, 05 Jan 2008 14:01:19 +0900
X-Dispatcher: imput version 20050308(IM148)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Deepak Colluru <deepakrc@gmail.com>
Subject: [PATCH] bsg : Add support for io vectors in bsg
Date: Fri, 4 Jan 2008 21:47:34 +0530 (IST)

> From: Deepak Colluru <deepakrc@gmail.com>
> 
> Add support for io vectors in bsg.
> 
> Signed-off-by: Deepak Colluru <deepakrc@gmail.com>
> ---
>   bsg.c |   52 +++++++++++++++++++++++++++++++++++++++++++++++++---
>   1 file changed, 49 insertions(+), 3 deletions(-)

Thanks, but I have to NACK this.

You can find the discussion about bsg io vector support and a similar
patch in linux-scsi archive. I have no plan to support it since it
needs the compat hack.
