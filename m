Return-Path: <linux-kernel-owner+w=401wt.eu-S1751014AbXCFVTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751014AbXCFVTS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 16:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751349AbXCFVTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 16:19:18 -0500
Received: from zrtps0kp.nortel.com ([47.140.192.56]:50038 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbXCFVTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 16:19:17 -0500
Message-ID: <45EDDA8F.5060106@nortel.com>
Date: Tue, 06 Mar 2007 15:18:07 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@linux-foundation.org>
CC: David Miller <davem@davemloft.net>, jeremy@goop.org, ak@muc.de,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       chrisw@sous-sol.org, zach@vmware.com, rusty@rustcorp.com.au,
       ian.pratt@xensource.com, Christian.Limpach@cl.cam.ac.uk,
       netdev@vger.kernel.org, jeff@garzik.org
Subject: Re: [RFC] ARP notify option
References: <20070301164214.4a40bc59@freekitty> <45E7764A.7000100@goop.org>	<20070301173030.754514ec@freekitty> <20070305.203536.92584097.davem@davemloft.net> <20070306105132.52c77491@freekitty>
In-Reply-To: <20070306105132.52c77491@freekitty>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Mar 2007 21:18:11.0447 (UTC) FILETIME=[F1CA2070:01C76034]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger wrote:

> +arp_notify - BOOLEAN
> +	Define mode for notification of address and device changes.
> +	0 - (default): do nothing
> +	1 - Generate gratuitous arp replies when device is brought up
> +	    or hardware address changes.

Did you consider using gratuitous arp requests instead?  I remember 
reading about some hardware that updated its arp cache on gratuitous 
requests but not gratuitous replies.

Chris
