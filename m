Return-Path: <linux-kernel-owner+w=401wt.eu-S1752637AbZGXOjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbZGXOjm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 10:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbZGXOjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 10:39:42 -0400
Received: from av9-1-sn2.hy.skanova.net ([81.228.8.179]:51368 "EHLO
	av9-1-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbZGXOjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 10:39:41 -0400
Message-ID: <4A69C7A5.3060903@mocean-labs.com>
Date: Fri, 24 Jul 2009 16:39:33 +0200
From: =?ISO-8859-1?Q?Richard_R=F6jfors?= 
	<richard.rojfors.ext@mocean-labs.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kwangwoo.lee@gmail.com,
       Thierry Reding <thierry.reding@avionic-design.de>,
       Trilok Soni <soni.trilok@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] tsc2007: remove HR timer
References: <4A40C288.2060702@mocean-labs.com> <20090714044957.GD2822@dtor-d630.eng.vmware.com>
In-Reply-To: <20090714044957.GD2822@dtor-d630.eng.vmware.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> 
> Could you please try the patch below and see if the touchscreen still
> works for you? It should be applied on top of your patch.

Sorry for coming back late, we switched I2C IP so I had to write a new 
driver for it before trying this out again.

The irq balancing seem to work as in you patch. I didn't run exactly
you patch, I took some of the changes into my code, since we can not
provide the callbacks.

I have also done some other small changes, to saves us one of five I2C 
transactions in polling mode.

I Will post this incremental patch in a couple of minutes.

Thanks
--Richard
