Return-Path: <linux-kernel-owner+w=401wt.eu-S1758001AbZLEXKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758001AbZLEXKA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 18:10:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757942AbZLEXJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 18:09:55 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49498
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757475AbZLEXJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 18:09:54 -0500
Date: Sat, 05 Dec 2009 15:10:01 -0800 (PST)
Message-Id: <20091205.151001.225544378.davem@davemloft.net>
To: viro@ftp.linux.org.uk
Cc: linux-arch@vger.kernel.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 8/18] file ->get_unmapped_area() shouldn't
 duplicate work of get_unmapped_area()
From: David Miller <davem@davemloft.net>
In-Reply-To: <E1NGzzu-0008RX-VJ@ZenIV.linux.org.uk>
References: <E1NGzzu-0008RX-VJ@ZenIV.linux.org.uk>
X-Mailer: Mew version 6.2 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 05 Dec 2009 19:08:50 +0000

> 
> ... we should call mm ->get_unmapped_area() instead and let our caller
> do the final checks.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Acked-by: David S. Miller <davem@davemloft.net>
