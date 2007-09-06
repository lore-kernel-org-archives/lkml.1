Return-Path: <linux-kernel-owner+w=401wt.eu-S1757964AbXIFMWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964AbXIFMWu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 08:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754452AbXIFMWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 08:22:40 -0400
Received: from smile.2scale.net ([212.12.33.142]:36508 "EHLO smile.2scale.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754961AbXIFMWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 08:22:39 -0400
Subject: Re: WARNING native_smp_call_function mask 2.6.22.6 SMP on Single
	CPU System
From: Michael Stiller <ms@2scale.net>
To: linux-kernel@vger.kernel.org
In-Reply-To: <1189076403.3595.17.camel@blackberry>
References: <1189076403.3595.17.camel@blackberry>
Content-Type: text/plain
Organization: 2scale GmbH
Date: Thu, 06 Sep 2007 14:22:29 +0200
Message-Id: <1189081349.3595.28.camel@blackberry>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-06 at 13:00 +0200, Michael Stiller wrote:
> Hi,
> 
> i get the following warning if i call vfree some memory allocated by
> vmalloc on a single cpu machine running 2.6.22.6 SMP:
> 
> WARNING: at arch/i386/kernel/smp.c:559 native_smp_call_function_mask()

Resolved. I called vfree with irqs disabled. Me stupid ;)

-Michael

