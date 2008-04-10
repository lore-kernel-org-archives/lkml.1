Return-Path: <linux-kernel-owner+w=401wt.eu-S1759335AbYDJVrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759335AbYDJVrT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 17:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757645AbYDJVrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 17:47:08 -0400
Received: from gate.crashing.org ([63.228.1.57]:42677 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757627AbYDJVrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 17:47:07 -0400
Subject: Re: [PATCH 1/2] Add thread_info_cache_init() to all archs
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: linux-kernel@vger.kernel.org
Cc: Linux-Arch <linux-arch@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       takata@linux-m32r.org, linux-m32r@ml.linux-m32r.org,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <20080410032354.90CB1DDF0F@ozlabs.org>
References: <20080410032354.90CB1DDF0F@ozlabs.org>
Content-Type: text/plain
Date: Fri, 11 Apr 2008 07:46:18 +1000
Message-Id: <1207863978.6958.15.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +#ifndef thread_info_cache_init
> +#define thread_info_cache_init	do { } while(0)
> +#endif
> +

Blah ! Missing a pair of () here. Ooops. I'll send a fixed patch.

Ben.


