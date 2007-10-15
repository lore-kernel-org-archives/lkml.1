Return-Path: <linux-kernel-owner+w=401wt.eu-S1758956AbXJODEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758956AbXJODEa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 23:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755385AbXJODEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 23:04:20 -0400
Received: from [203.178.140.9] ([203.178.140.9]:47144 "EHLO mail.gomagoma.org"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755199AbXJODET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 23:04:19 -0400
X-Greylist: delayed 1329 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Oct 2007 23:04:19 EDT
Date: Mon, 15 Oct 2007 11:45:10 +0900
From: Masahide NAKAMURA <nakam@linux-ipv6.org>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] __inet6_csk_dst_store(): fix check-after-use
Cc: Noriaki TAKAMIYA <takamiya@po.ntts.co.jp>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071014175212.GP4211@stusta.de>
References: <20071014175212.GP4211@stusta.de>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20071015113723.00F7.NAKAM@linux-ipv6.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.40.04 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 14 Oct 2007 19:52:12 +0200
Adrian Bunk <bunk@kernel.org> wrote:

> The Coverity checker spotted that we have already oops'ed if "dst"
> was NULL.
> 
> Since "dst" being NULL doesn't seem to be possible at this point this 
> patch removes the NULL check.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Agreed.

Acked-by: Masahide NAKAMURA <nakam@linux-ipv6.org>

-- 
Masahide NAKAMURA

