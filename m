Return-Path: <linux-kernel-owner+w=401wt.eu-S1760356AbXHOAkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760356AbXHOAkV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 20:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755260AbXHOAj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 20:39:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48612
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754632AbXHOAj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 20:39:57 -0400
Date: Tue, 14 Aug 2007 17:39:57 -0700 (PDT)
Message-Id: <20070814.173957.18578051.davem@davemloft.net>
To: bunk@kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] net/8021q/vlanproc.c: fix check-after-use
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070814212244.GB18945@stusta.de>
References: <20070814212244.GB18945@stusta.de>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>
Date: Tue, 14 Aug 2007 23:22:44 +0200

> The Coverity checker spotted that we'd have already oops'ed if "vlandev"
> was NULL.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Fair enough, applied, thanks Adrian.
