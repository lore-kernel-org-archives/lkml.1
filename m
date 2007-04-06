Return-Path: <linux-kernel-owner+w=401wt.eu-S1767505AbXDFCXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767505AbXDFCXb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 22:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767504AbXDFCXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 22:23:30 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:26157 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767507AbXDFCX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 22:23:29 -0400
X-IronPort-AV: i="4.14,380,1170651600"; 
   d="scan'208"; a="33925249:sNHT20779388"
Subject: Re: [PATCH] USB gadget rndis: fix bug skb_push function may return
	an unaligned pointer bug
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: David Brownell <david-b@pacbell.net>, jie.zhang@analog.com,
       roy.huang@analog.com
Cc: bryan.wu@analog.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200704051429.04147.david-b@pacbell.net>
References: <1175668113.10608.41.camel@roc-desktop>
	 <200704051429.04147.david-b@pacbell.net>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Fri, 06 Apr 2007 10:25:18 +0800
Message-Id: <1175826318.17315.57.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-05 at 14:29 -0700, David Brownell wrote:
> On Tuesday 03 April 2007 11:28 pm, Wu, Bryan wrote:
> > USB gadget rndis: skb_push function may return a pointer which is not
> > aligned as required by struct rndis_packet_msg_type.
> 
> Can you instead try to update the declaration of that struct
> so that it's "__attribute__((packed))"?  That's less invasive,
> and will address similar issues elsewhere ...
> 
> - Dave

OK, Jie and Roy will try to use this __attribute__ method and test it on
blackfin platform. Sorry for missing their "Signed-off-by". I will
resend a patch later for review.

Thanks
-Bryan

