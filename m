Return-Path: <linux-kernel-owner+w=401wt.eu-S1757191AbZKWLBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191AbZKWLBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 06:01:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757169AbZKWLBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 06:01:14 -0500
Received: from mail-ew0-f215.google.com ([209.85.219.215]:57751 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756845AbZKWLBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 06:01:10 -0500
X-Greylist: delayed 344 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Nov 2009 06:01:09 EST
Subject: Re: [PATCH] drivers/regulator: use PTR_ERR to get error code
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Julia Lawall <julia@diku.dk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0911212218210.28848@ask.diku.dk>
References: <Pine.LNX.4.64.0911212218210.28848@ask.diku.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Nov 2009 10:55:58 +0000
Message-ID: <1258973758.3629.64.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-11-21 at 22:18 +0100, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> IS_ERR returns only 1 or 0.  The callsite of setup_regulators expects a
> negative integer in an error case.  Thus, PTR_ERR has to be used to extract
> it.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression E,E1;
> @@
> 
> *E = IS_ERR(...)
>  ... when != E = E1
> *return E;
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 

Applied.

Thanks

Liam

