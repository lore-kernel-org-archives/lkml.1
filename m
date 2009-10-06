Return-Path: <linux-kernel-owner+w=401wt.eu-S933554AbZJFXeM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933554AbZJFXeM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 19:34:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933472AbZJFXeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 19:34:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38245
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933416AbZJFXeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 19:34:10 -0400
Date: Tue, 06 Oct 2009 16:34:05 -0700 (PDT)
Message-Id: <20091006.163405.63274351.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: torvalds@linux-foundation.org, joao.ramos@inov.pt, david@fries.net,
       d.stussy@yahoo.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Revert "Revert "ide: try to use PIO Mode 0 during
 probe if possible""
From: David Miller <davem@davemloft.net>
In-Reply-To: <200910070113.05996.bzolnier@gmail.com>
References: <200910070052.37964.bzolnier@gmail.com>
	<20091006.155705.26059456.davem@davemloft.net>
	<200910070113.05996.bzolnier@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Wed, 7 Oct 2009 01:13:05 +0200

> Many embedded controllers/platforms will have junk PIO timings set initially.

Thanks, that helps a lot.

When David reports back on testing I'll push this stuff around
and queue up patch #1 for -stable.
