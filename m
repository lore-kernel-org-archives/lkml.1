Return-Path: <linux-kernel-owner+w=401wt.eu-S1751230AbZKPFNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751230AbZKPFNg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 00:13:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750761AbZKPFNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 00:13:35 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58680
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750734AbZKPFNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 00:13:35 -0500
Date: Sun, 15 Nov 2009 21:13:51 -0800 (PST)
Message-Id: <20091115.211351.11441017.davem@davemloft.net>
To: arnd@arndb.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/12] hamradio/mkiss: fix typo in compat_ioctl
From: David Miller <davem@davemloft.net>
In-Reply-To: <1258331227-1694-12-git-send-email-arnd@arndb.de>
References: <1258331227-1694-1-git-send-email-arnd@arndb.de>
	<1258331227-1694-12-git-send-email-arnd@arndb.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 16 Nov 2009 00:27:06 +0000

> My last commit introduced an typo causing the
> compat_ioctl function to do nothing useful.
> The obvious way for an ioctl function to work
> is to look at the command, not the argument first.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied, but please CC: netdev on all networking patches so that
they get properly tracked in patchwork.

Thanks.
