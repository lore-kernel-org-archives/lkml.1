Return-Path: <linux-kernel-owner+w=401wt.eu-S1753815AbZALMCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815AbZALMCz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 07:02:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbZALMCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 07:02:47 -0500
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:21688 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752105AbZALMCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 07:02:46 -0500
Message-ID: <496B3105.6030107@gentoo.org>
Date: Mon, 12 Jan 2009 12:01:09 +0000
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090101)
MIME-Version: 1.0
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>, klausman@gentoo.org,
       rth@twiddle.net
Subject: Re: cant compile on alpha with gcc-4.3 and CONFIG_ALPHA_NAUTILUS
References: <49688C67.5050502@gentoo.org> <20090111210532.GA1641@jurassic.park.msu.ru>
In-Reply-To: <20090111210532.GA1641@jurassic.park.msu.ru>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.0 c=1 a=9jjR1oMCFskA:10 a=vxFckkwZ0Y8A:10 a=zEchxxm6Pp8P_IKT8l0A:9 a=TdNDaFbkBhLkypn4nv5MW8JhgXAA:4 a=csDljm-qqwUA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ivan Kokshaysky wrote:
> Your patch looks fine, but there is simpler fix which makes the compiler
> to optimize problematic code away on systems with NR_IRQS <= 16.

Yes, I guess that works too. Would you like me to submit that to Andrew 
or are you going to take care of it?

cheers
Daniel

