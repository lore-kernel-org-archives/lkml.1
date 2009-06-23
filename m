Return-Path: <linux-kernel-owner+w=401wt.eu-S1759561AbZFWNhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759561AbZFWNhc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 09:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759134AbZFWNhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 09:37:19 -0400
Received: from relay.atmel.no ([80.232.32.139]:59549 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756499AbZFWNhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 09:37:18 -0400
Date: Tue, 23 Jun 2009 15:35:56 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, plagnioj@jcrosoft.com,
       linux-kernel@vger.kernel.org, avictor.za@gmail.com,
       nicolas.ferre@atmel.com
Subject: Re: [RFC PATCH] atmel_lcdfb Kconfig: remove long dependency line
Message-ID: <20090623153556.0e574899@hskinnemoen-d830>
In-Reply-To: <1245767456-6434-1-git-send-email-nicolas.ferre@atmel.com>
References: <4A40D695.5000302@atmel.com>
	<1245767456-6434-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Ferre wrote:
> +config ARCH_ATMEL_HAS_FB
> +	bool
> +	depends on FB
> +	default n

What happens when we unconditionally select something which depends on
something else?

Haavard
