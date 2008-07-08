Return-Path: <linux-kernel-owner+w=401wt.eu-S1756147AbYGHKDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147AbYGHKDp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 06:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752728AbYGHKDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 06:03:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36496
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752131AbYGHKDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 06:03:33 -0400
Date: Tue, 08 Jul 2008 03:03:33 -0700 (PDT)
Message-Id: <20080708.030333.169790510.davem@davemloft.net>
To: richard@rsk.demon.co.uk
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: remove padding from struct socket on 64bit &
 increase objects/cache
From: David Miller <davem@davemloft.net>
In-Reply-To: <1215431890.3101.5.camel@castor.localdomain>
References: <1215431890.3101.5.camel@castor.localdomain>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Kennedy <richard@rsk.demon.co.uk>
Date: Mon, 07 Jul 2008 12:58:10 +0100

> remove padding from struct socket reducing its size by 8 bytes.
>     
> This allows more objects/cache in sock_inode_cache
> 12 objects/cache when cacheline size is 128 (generic x86_64)
>     
> Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

Applied to net-next-2.6, thanks!
