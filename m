Return-Path: <linux-kernel-owner+w=401wt.eu-S1762374AbXFRKvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762374AbXFRKvh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 06:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755657AbXFRKv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 06:51:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42869
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1762130AbXFRKv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 06:51:26 -0400
Date: Mon, 18 Jun 2007 03:51:44 -0700 (PDT)
Message-Id: <20070618.035144.64026005.davem@davemloft.net>
To: miklos@szeredi.hu
Cc: tgraf@suug.ch, akpm@linux-foundation.org, viro@ftp.linux.org.uk,
       alan@lxorguk.ukuu.org.uk, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix race in AF_UNIX
From: David Miller <davem@davemloft.net>
In-Reply-To: <E1I0ElR-0007Kz-00@dorka.pomaz.szeredi.hu>
References: <20070618103241.GX521@postel.suug.ch>
	<20070618104059.GY521@postel.suug.ch>
	<E1I0ElR-0007Kz-00@dorka.pomaz.szeredi.hu>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 18 Jun 2007 12:47:17 +0200

> but it's not as if it's really going to affect performance
> in real cases.

Since these circumstances are creatable by any user, we have
to consider the cases caused by malicious entities.
