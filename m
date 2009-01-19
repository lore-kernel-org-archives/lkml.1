Return-Path: <linux-kernel-owner+w=401wt.eu-S1758548AbZASFdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758548AbZASFdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 00:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753035AbZASFdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 00:33:08 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41795
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751415AbZASFdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 00:33:07 -0500
Date: Sun, 18 Jan 2009 21:33:08 -0800 (PST)
Message-Id: <20090118.213308.214103172.davem@davemloft.net>
To: roel.kluin@gmail.com
Cc: ericvh@gmail.com, rminnich@sandia.gov, lucho@ionkov.net,
       v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/9p: fid->fid is used uninitialized
From: David Miller <davem@davemloft.net>
In-Reply-To: <49737EA1.3080805@gmail.com>
References: <49737EA1.3080805@gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <roel.kluin@gmail.com>
Date: Sun, 18 Jan 2009 20:10:25 +0100

> fid->fid is used uninitialized
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Applied, thanks Roel.

Someone should look into how p9_idpool_get() errors are
propagated.  Another call site uses -ENOBUFS, this location
uses -ENOSPC, and it begs the question whether we should
just use the error return given by p9_idpool_get() across
the board.
