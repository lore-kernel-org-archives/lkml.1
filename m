Return-Path: <linux-kernel-owner+w=401wt.eu-S1754730AbZFSIBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbZFSIBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 04:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbZFSIBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 04:01:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47981
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751591AbZFSIBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 04:01:08 -0400
Date: Fri, 19 Jun 2009 01:01:11 -0700 (PDT)
Message-Id: <20090619.010111.07039165.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: linux-kernel@vger.kernel.org
Subject: Re: backtrace symbols are bolixed...
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090619173052.8460f1a9.sfr@canb.auug.org.au>
References: <20090619.002101.45610359.davem@davemloft.net>
	<20090619173052.8460f1a9.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 19 Jun 2009 17:30:52 +1000

> Try the following patch:
> 
> From: Mike Frysinger <vapier@gentoo.org>
> Date: Mon, 15 Jun 2009 07:52:48 -0400
> Subject: [PATCH] kallsyms: fix inverted valid symbol checking
> 
> The previous commit (17b1f0de) introduced a slightly broken consolidation
> of the memory text range checking.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

That fixed it, thanks!
