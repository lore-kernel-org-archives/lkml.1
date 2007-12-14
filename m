Return-Path: <linux-kernel-owner+w=401wt.eu-S934000AbXLNQQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934000AbXLNQQ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 11:16:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755370AbXLNQQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 11:16:49 -0500
Received: from smtp-105-friday.noc.nerim.net ([62.4.17.105]:2172 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753668AbXLNQQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 11:16:48 -0500
Date: Fri, 14 Dec 2007 17:16:46 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "eric miao" <eric.y.miao@gmail.com>
Cc: "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       i2c@lm-sensors.org, David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH 0/2] gpiolib: add support for PCA9539
Message-ID: <20071214171646.0fe5a876@hyperion.delvare>
In-Reply-To: <f17812d70712100137h3aa0056bq78b0efb92d072891@mail.gmail.com>
References: <f17812d70712100137h3aa0056bq78b0efb92d072891@mail.gmail.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On Mon, 10 Dec 2007 17:37:05 +0800, eric miao wrote:
> Support for PCA9539 as a GPIO chip is separated into two patches:
> 
> 0001 - gpiolib: basic support for 16-bit PCA9539 GPIO expander
> 0002 - gpiolib: add Generic IRQ support for 16-bit PCA9539 GPIO expander
> 
> the 2nd one uses workqueue for IRQ handling due to the interrupt mode
> nature of the i2c-core, thus making it a separate patch.

Note that the situation could change according to the discussion in
this thread:
http://lists.lm-sensors.org/pipermail/i2c/2007-December/002378.html

-- 
Jean Delvare
