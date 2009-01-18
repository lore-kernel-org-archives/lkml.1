Return-Path: <linux-kernel-owner+w=401wt.eu-S1761724AbZARHJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761724AbZARHJO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 02:09:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756191AbZARHIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 02:08:54 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39008
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756077AbZARHIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 02:08:53 -0500
Date: Sat, 17 Jan 2009 23:08:55 -0800 (PST)
Message-Id: <20090117.230855.174885754.davem@davemloft.net>
To: jirislaby@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: Re: [PATCH 1/1] NET: net_namespace, fix lock imbalance
From: David Miller <davem@davemloft.net>
In-Reply-To: <1232210832-30041-1-git-send-email-jirislaby@gmail.com>
References: <1232210832-30041-1-git-send-email-jirislaby@gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>
Date: Sat, 17 Jan 2009 17:47:12 +0100

> register_pernet_gen_subsys omits mutex_unlock in one fail path.
> Fix it.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

Applied, thanks.
