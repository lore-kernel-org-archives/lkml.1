Return-Path: <linux-kernel-owner+w=401wt.eu-S1754379AbYHJKu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379AbYHJKu2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 06:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbYHJKuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 06:50:18 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:45907 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700AbYHJKuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 06:50:17 -0400
Date: Sun, 10 Aug 2008 13:48:37 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Rene Herman <rene.herman@gmail.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Adam M Belay <abelay@MIT.EDU>,
       linux-kernel@vger.kernel.org
Subject: [2.6 patch] pnp: remove printk() with outdated version
Message-ID: <20080810104837.GB16146@cs181140183.pp.htv.fi>
References: <20080806211023.GD1702@cs181140183.pp.htv.fi> <489A19D1.9070507@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <489A19D1.9070507@keyaccess.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2008 at 11:38:25PM +0200, Rene Herman wrote:
> On 06-08-08 23:10, Adrian Bunk wrote:
>
>> There's no point in printing some ancient version number forever.
>>
>> Signed-off-by: Adrian Bunk <bunk@kernel.org>
>> Acked-by; Rene Herman <rene.herman@gmail.com>
>> Acked-by; Bjorn Helgaas <bjorn.helgaas@hp.com>
>> Acked-by; Adam M Belay <abelay@MIT.EDU>
>
> semicolons... :-/
>...

Fixed patch below.

> Rene.

cu
Adrian


<--  snip  -->


There's no point in printing some ancient version number forever.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Rene Herman <rene.herman@gmail.com>
Acked-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-by: Adam M Belay <abelay@MIT.EDU>

---
There's no point in printing some ancient version number forever.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
acef517cfbe3cd741f8884311ef6fc2dfbeb1a4d diff --git a/drivers/pnp/core.c b/drivers/pnp/core.c
index 20771b7..d924798 100644
--- a/drivers/pnp/core.c
+++ b/drivers/pnp/core.c
@@ -209,7 +209,6 @@ void __pnp_remove_device(struct pnp_dev *dev)
 
 static int __init pnp_init(void)
 {
-	printk(KERN_INFO "Linux Plug and Play Support v0.97 (c) Adam Belay\n");
 	return bus_register(&pnp_bus_type);
 }
 

