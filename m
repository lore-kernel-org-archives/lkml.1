Return-Path: <linux-kernel-owner+w=401wt.eu-S1756690Ab0AOA6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690Ab0AOA6j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 19:58:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755854Ab0AOA6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 19:58:38 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34849
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755413Ab0AOA6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 19:58:38 -0500
Date: Thu, 14 Jan 2010 16:58:47 -0800 (PST)
Message-Id: <20100114.165847.126963317.davem@davemloft.net>
To: roel.kluin@gmail.com
Cc: sparclinux@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc: leds_resource.end assigned to itself in
 clock_board_probe()
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B4F4C9B.9040202@gmail.com>
References: <4B4F4C9B.9040202@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <roel.kluin@gmail.com>
Date: Thu, 14 Jan 2010 17:55:55 +0100

> These statements appear redundant.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Is there any reason to assign this to itself?

It's a bug, let me try and figure out what this code is trying
to do.
