Return-Path: <linux-kernel-owner+w=401wt.eu-S1755494AbZFBXJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbZFBXJq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 19:09:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753237AbZFBXJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 19:09:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52418 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752546AbZFBXJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 19:09:38 -0400
Date: Tue, 2 Jun 2009 16:09:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Baruch Siach <baruch@tkos.co.il>
Cc: linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net,
       linux-arm-kernel@lists.arm.linux.org.uk, linux@arm.linux.org.uk,
       baruch@tkos.co.il
Subject: Re: [PATCH v3] gpio: driver for PrimeCell PL061 GPIO controller
Message-Id: <20090602160902.046ccffa.akpm@linux-foundation.org>
In-Reply-To: <1243975690-12073-1-git-send-email-baruch@tkos.co.il>
References: <1243975690-12073-1-git-send-email-baruch@tkos.co.il>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  2 Jun 2009 23:48:10 +0300
Baruch Siach <baruch@tkos.co.il> wrote:

> This is a driver for the ARM PrimeCell PL061 GPIO AMBA peripheral. The driver
> is implemented using the gpiolib framework.

x86_64 allmodconfig:

drivers/gpio/pl061.c: In function 'pl061_probe':
drivers/gpio/pl061.c:254: error: 'SZ_4K' undeclared (first use in this function)
drivers/gpio/pl061.c:254: error: (Each undeclared identifier is reported only once
drivers/gpio/pl061.c:254: error: for each function it appears in.)
drivers/gpio/pl061.c:306: error: implicit declaration of function 'set_irq_flags'
drivers/gpio/pl061.c:306: error: 'IRQF_VALID' undeclared (first use in this function)

I'll put a depends-on-ARM in there...
