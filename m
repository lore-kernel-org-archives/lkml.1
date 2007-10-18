Return-Path: <linux-kernel-owner+w=401wt.eu-S1762331AbXJRJkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762331AbXJRJkk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 05:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755637AbXJRJk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 05:40:29 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4447 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755528AbXJRJk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 05:40:28 -0400
Date: Thu, 18 Oct 2007 10:40:13 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: leoli@freescale.com, jgarzik@pobox.com, paulus@samba.org,
       galak@kernel.crashing.org, afleming@freescale.com,
       linuxppc-dev@ozlabs.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][NET] gianfar: fix obviously wrong #ifdef CONFIG_GFAR_NAPI placement
Message-ID: <20071018094013.GU21136@shadowen.org>
References: <20071017195746.GA15592@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017195746.GA15592@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The check then is to see if a non {}'d block has no statements in it if the
ifdef is null.  Hmmm.  May be possible.  Will think on it.

        if (err)
+#ifdef CONFIG_GFAR_NAPI
                napi_disable(&priv->napi);
+#endif

-apw
