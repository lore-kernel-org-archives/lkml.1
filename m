Return-Path: <linux-kernel-owner+w=401wt.eu-S1763044AbYEFOmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763044AbYEFOmE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 10:42:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762094AbYEFOls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 10:41:48 -0400
Received: from ag-out-0708.google.com ([72.14.246.244]:33984 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761919AbYEFOlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 10:41:47 -0400
Message-ID: <fa686aa40805060741vd4befa4i1ea5ab6df4d54d9b@mail.gmail.com>
Date: Tue, 6 May 2008 08:41:44 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Greg KH" <greg@kroah.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Fwd: [PATCH] [POWERPC] mpc5200: Fix unterminated of_device_id table
In-Reply-To: <20080429124343.24177.15349.stgit@trillian.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080429124343.24177.15349.stgit@trillian.secretlab.ca>
X-Google-Sender-Auth: 50d6a7a304a8867f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

This patch is already in mainline; but it needs to be backported to
the stable tree.  Can you please pick it up?

Thanks,
g.


---------- Forwarded message ----------
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, Apr 29, 2008 at 6:43 AM
Subject: [PATCH] [POWERPC] mpc5200: Fix unterminated of_device_id table
To: linuxppc-dev@ozlabs.org, linux_kernel@vger.kernel.org, paulus@samba.org


From: Grant Likely <grant.likely@secretlab.ca>

 If CONFIG_PPC_MPC5121 is not set, then the of_device_id table for the
 mpc5200 serial driver will not get terminated with a NULL entry.

 Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
 ---

  drivers/serial/mpc52xx_uart.c |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

 diff --git a/drivers/serial/mpc52xx_uart.c b/drivers/serial/mpc52xx_uart.c
 index d93b357..7a3625f 100644
 --- a/drivers/serial/mpc52xx_uart.c
 +++ b/drivers/serial/mpc52xx_uart.c
 @@ -1221,8 +1221,8 @@ static struct of_device_id mpc52xx_uart_of_match[] = {
  #endif
  #ifdef CONFIG_PPC_MPC512x
        { .compatible = "fsl,mpc5121-psc-uart", .data = &mpc512x_psc_ops, },
 -       {},
  #endif
 +       {},
  };

  static int __devinit




-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
