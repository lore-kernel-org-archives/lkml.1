Return-Path: <linux-kernel-owner+w=401wt.eu-S1757360AbYESDbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360AbYESDbj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 23:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754586AbYESDb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 23:31:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57725
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754067AbYESDbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 23:31:21 -0400
Date: Sun, 18 May 2008 20:31:16 -0700 (PDT)
Message-Id: <20080518.203116.199516667.davem@davemloft.net>
To: galak@kernel.crashing.org
Cc: paulus@samba.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] lmb: Fix compile warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <1211136296-4572-2-git-send-email-galak@kernel.crashing.org>
References: <1211136296-4572-1-git-send-email-galak@kernel.crashing.org>
	<1211136296-4572-2-git-send-email-galak@kernel.crashing.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kumar Gala <galak@kernel.crashing.org>
Date: Sun, 18 May 2008 13:44:53 -0500

> lib/lmb.c: In function 'lmb_dump_all':
> lib/lmb.c:51: warning: format '%lx' expects type 'long unsigned int', but argument 2 has type 'u64'
> 
> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>

That's not right either.

We'll need to cast this argument because it's a different type on sparc
vs sparc64 vs powerpc.

u64 != unsigned long long
