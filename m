Return-Path: <linux-kernel-owner+w=401wt.eu-S1755418AbXJYV0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418AbXJYV0W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 17:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752862AbXJYV0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 17:26:15 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46332 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752633AbXJYV0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 17:26:14 -0400
Date: Thu, 25 Oct 2007 14:26:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Florian Fainelli <florian.fainelli@telecomint.eu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH 3/4] [x86] : Add support for the RDC R-321x SoC
Message-Id: <20071025142611.a1bb9088.akpm@linux-foundation.org>
In-Reply-To: <200710161341.32077.florian.fainelli@telecomint.eu>
References: <200710161341.32077.florian.fainelli@telecomint.eu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2007 13:41:31 +0200
Florian Fainelli <florian.fainelli@telecomint.eu> wrote:

> +static struct {
> +	struct completion stop;
> +	volatile int running;
> +	struct timer_list timer;
> +	volatile int queue;
> +	int default_ticks;
> +	unsigned long inuse;
> +} rdc321x_wdt_device;

Why the volatiles?  If these actually help then it's probably an indication
that something is wrong in the implementation.

Documentation/volatile-considered-harmful.txt has some details.
