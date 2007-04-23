Return-Path: <linux-kernel-owner+w=401wt.eu-S1754283AbXDWV7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283AbXDWV7E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 17:59:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754307AbXDWV7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 17:59:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55229
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754283AbXDWV7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 17:59:02 -0400
Date: Mon, 23 Apr 2007 14:59:09 -0700 (PDT)
Message-Id: <20070423.145909.31640377.davem@davemloft.net>
To: voron@amhost.net
Cc: linux-kernel@vger.kernel.org
Subject: Re: sendfile to nonblocking socket
From: David Miller <davem@davemloft.net>
In-Reply-To: <462D2177.1060609@amhost.net>
References: <462D2177.1060609@amhost.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: voron <voron@amhost.net>
Date: Tue, 24 Apr 2007 00:13:27 +0300

> As I see, nonblocking mode is enabled - sendfile sends less than asked.  

The socket is marked as non-blocking, but the disk I/O is not.

It's blocking on the disk I/O not the socket part of the operation.
