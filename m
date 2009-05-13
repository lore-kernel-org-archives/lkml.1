Return-Path: <linux-kernel-owner+w=401wt.eu-S1756893AbZEMHRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893AbZEMHRl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 03:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751980AbZEMHRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 03:17:32 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:5020 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbZEMHRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 03:17:32 -0400
MIME-Version: 1.0
In-Reply-To: <20090513060850.GZ31071@waste.org>
References: <alpine.DEB.2.00.0905130118140.15823@ubuntu-desktop>
	 <20090513060850.GZ31071@waste.org>
Date: Wed, 13 May 2009 00:17:29 -0700
Message-ID: <a24804730905130017t545b7645x71ab7a1c8ab4af78@mail.gmail.com>
Subject: Re: [PATCH] [resend] drivers/net: remove network drivers' last few 
	uses of IRQF_SAMPLE_RANDOM
From: Chris Peterson <cpeterso@cpeterso.com>
To: Matt Mackall <mpm@selenic.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The future model will continue to sample network
> devices on theory that they -might- be less than 100% observable and
> that can only increase our total (unmeasurable) amount of entropy.

That sounds reasonable to me. So should all net drivers now specify
IRQF_SAMPLE_RANDOM?

Or even simpler: could request_irq() assume IRQF_SAMPLE_RANDOM for any
interrupt that is not (say) IRQF_IRQPOLL or IRQF_PERCPU?

chris
