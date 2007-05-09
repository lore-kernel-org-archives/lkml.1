Return-Path: <linux-kernel-owner+w=401wt.eu-S1034022AbXEIDTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1034022AbXEIDTm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 23:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1033333AbXEIDT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 23:19:29 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:20966 "EHLO
	asav19.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033206AbXEIDT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 23:19:28 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuE6AETaQEZKhRO4W2dsb2JhbACBXI4VHQ0FEQE
From: Dmitry Torokhov <dtor@insightbb.com>
To: Roland Scheidegger <sroland@tungstengraphics.com>
Subject: Re: [PATCH] input: fix aux port detection with some i8042 chips
Date: Tue, 8 May 2007 23:19:29 -0400
User-Agent: KMail/1.9.3
Cc: linux-kernel@vger.kernel.org
References: <463A7291.1050600@tungstengraphics.com>
In-Reply-To: <463A7291.1050600@tungstengraphics.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705082319.30099.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 May 2007 19:38, Roland Scheidegger wrote:
> From: Roland Scheidegger <sroland@tungstengraphics.com>
> 
> The i8042 driver fails detection of the AUX port with some chips,
> because they apparently do not change the I8042_CTR_AUXDIS bit
> immediately. This is known to affect at least HP500 / HP510 notebooks,
> consequently the built-in touchpad will not work. The patch will simply
> reread the value until it gets the expected value or a retry limit is
> hit, without touching other workaround code in the same area.
> 

Applied with some rearrangements, thank you.

-- 
Dmitry
