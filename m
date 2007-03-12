Return-Path: <linux-kernel-owner+w=401wt.eu-S965877AbXCLOHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965877AbXCLOHl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 10:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965876AbXCLOHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 10:07:40 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50433 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965490AbXCLOHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 10:07:39 -0400
Message-ID: <45F55EA5.9080005@garzik.org>
Date: Mon, 12 Mar 2007 10:07:33 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Valerie Henson <val_henson@linux.intel.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [patch 4/4] [TULIP] Rev tulip version
References: <20070312093128.577087000@linux.intel.com>	 <20070312095912.743760000@linux.intel.com> <84144f020703120344n3f5ed52axf0bc1c109b549535@mail.gmail.com>
In-Reply-To: <84144f020703120344n3f5ed52axf0bc1c109b549535@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> Hi,
> 
> On 3/12/07, Valerie Henson <val_henson@linux.intel.com> wrote:
>> --- tulip-2.6-mm-linux.orig/drivers/net/tulip/tulip_core.c
>> +++ tulip-2.6-mm-linux/drivers/net/tulip/tulip_core.c
>> @@ -17,11 +17,11 @@
>>
>>  #define DRV_NAME       "tulip"
>>  #ifdef CONFIG_TULIP_NAPI
>> -#define DRV_VERSION    "1.1.14-NAPI" /* Keep at least for test */
>> +#define DRV_VERSION    "1.1.15-NAPI" /* Keep at least for test */
>>  #else
>> -#define DRV_VERSION    "1.1.14"
>> +#define DRV_VERSION    "1.1.15"
>>  #endif
>> -#define DRV_RELDATE    "May 11, 2002"
>> +#define DRV_RELDATE    "Feb 27, 2007"
> 
> Why not just drop this? What purpose does a per-module revision have
> for in-kernel drivers anyway?

It's the maintainer's call.  Sometimes it eases parsing bug reports, and 
tracking changes as your drivers get backported to various enterprise 
operating systems(tm).  Sometimes it just gets in the way.

	Jeff



