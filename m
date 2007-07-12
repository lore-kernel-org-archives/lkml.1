Return-Path: <linux-kernel-owner+w=401wt.eu-S1765259AbXGLC6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765259AbXGLC6X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 22:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933664AbXGLC6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 22:58:11 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:47041 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764301AbXGLC6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 22:58:09 -0400
Date: Wed, 11 Jul 2007 20:01:32 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH 1/5] try parent numa_node at first before using default
In-reply-to: <46959651.1050400@s5r6.in-berlin.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>, rientjes@google.com,
       Christoph Lameter <clameter@sgi.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
Reply-to: Yinghai.Lu@Sun.COM
Message-id: <4695998C.8090100@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
References: <200707101641.17672.yinghai.lu@sun.com>
 <200707101652.31378.yinghai.lu@sun.com> <4694B702.2050507@s5r6.in-berlin.de>
 <20070711210833.GA22745@kroah.com> <46954B92.8000407@sun.com>
 <46959651.1050400@s5r6.in-berlin.de>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Yinghai Lu wrote:
>> original default is -1, and this patch just try to use parent's node as
>> default.
> 
> But in many cases, the patch does so at a time when the parent is not
> yet known.
then it will use -1.

YH
