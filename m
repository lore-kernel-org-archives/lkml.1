Return-Path: <linux-kernel-owner+w=401wt.eu-S1758418AbYLLFcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758418AbYLLFcc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 00:32:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757525AbYLLFcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 00:32:07 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37848
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757570AbYLLFb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 00:31:59 -0500
Date: Thu, 11 Dec 2008 21:32:00 -0800 (PST)
Message-Id: <20081211.213200.180924446.davem@davemloft.net>
To: paul.moore@hp.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       geert.uytterhoeven@sonycom.com
Subject: Re: [PATCH] netlabel: Compiler warning and NULL pointer
 dereference fix
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081211184312.30832.25526.stgit@flek.lan>
References: <20081211184312.30832.25526.stgit@flek.lan>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Moore <paul.moore@hp.com>
Date: Thu, 11 Dec 2008 13:43:12 -0500

> Fix the two compiler warnings show below.  Thanks to Geert Uytterhoeven for
> finding and reporting the problem.
> 
>  net/netlabel/netlabel_unlabeled.c:567: warning: 'entry' may be used
>    uninitialized in this function
>  net/netlabel/netlabel_unlabeled.c:629: warning: 'entry' may be used
>    uninitialized in this function
> 
> Signed-off-by: Paul Moore <paul.moore@hp.com>

Applied, thanks Paul.
