Return-Path: <linux-kernel-owner+w=401wt.eu-S1760225AbZKGE0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760225AbZKGE0V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 23:26:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760204AbZKGE0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 23:26:20 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56764
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760188AbZKGE0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 23:26:19 -0500
Date: Fri, 06 Nov 2009 20:26:44 -0800 (PST)
Message-Id: <20091106.202644.38012917.davem@davemloft.net>
To: jirislaby@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] NET: cassini, fix lock imbalance
From: David Miller <davem@davemloft.net>
In-Reply-To: <1257498869-4374-1-git-send-email-jirislaby@gmail.com>
References: <1257498869-4374-1-git-send-email-jirislaby@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>
Date: Fri,  6 Nov 2009 10:14:29 +0100

> Stanse found that one error path in cas_open omits to unlock pm_mutex.
> Fix that.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

Applied to net-2.6
