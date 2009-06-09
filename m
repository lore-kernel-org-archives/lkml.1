Return-Path: <linux-kernel-owner+w=401wt.eu-S1758179AbZFIL0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179AbZFIL0d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 07:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757034AbZFIL0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 07:26:24 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39422
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756752AbZFIL0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 07:26:23 -0400
Date: Tue, 09 Jun 2009 04:26:25 -0700 (PDT)
Message-Id: <20090609.042625.194310688.davem@davemloft.net>
To: wg@grandegger.com
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: net tree build warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <4A2E46A7.6020302@grandegger.com>
References: <20090609203639.96e503fe.sfr@canb.auug.org.au>
	<4A2E46A7.6020302@grandegger.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfgang Grandegger <wg@grandegger.com>
Date: Tue, 09 Jun 2009 13:25:27 +0200

> [PATCH] can: sja1000_of_platform: fix build problems with printk format
> 
> Variables of type size_t should be printed with the format "%zx".
> 
> Signed-off-by: Wolfgang Grandegger <wg@grandegger.com>

It's not a "size_t", it's a "resource_size_t" which can be
"unsigned long long" on some platforms.
