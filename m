Return-Path: <linux-kernel-owner+w=401wt.eu-S1753056Ab0AJV2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056Ab0AJV2J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 16:28:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753642Ab0AJV2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 16:28:07 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41893
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753916Ab0AJV2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 16:28:05 -0500
Date: Sun, 10 Jan 2010 13:28:13 -0800 (PST)
Message-Id: <20100110.132813.21319484.davem@davemloft.net>
To: jslaby@suse.cz
Cc: samuel@sortiz.org, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       alan@linux.intel.com, gregkh@suse.de, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] NET: irda, remove unnecessary checks
From: David Miller <davem@davemloft.net>
In-Reply-To: <1263122254-18781-1-git-send-email-jslaby@suse.cz>
References: <1263114674-10433-1-git-send-email-jslaby@suse.cz>
	<1263122254-18781-1-git-send-email-jslaby@suse.cz>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>
Date: Sun, 10 Jan 2010 12:17:34 +0100

> Stanse found a potential null dereference in ircomm_tty_close
> and ircomm_tty_hangup. There is a check for tty being NULL,
> but it is dereferenced earlier. But it is bogus, the tty cannot
> be NULL, so remove the !tty checks.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>

Applied.
