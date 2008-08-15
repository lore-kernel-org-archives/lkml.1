Return-Path: <linux-kernel-owner+w=401wt.eu-S1760905AbYHOV6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760905AbYHOV6y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 17:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbYHOV6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 17:58:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50571 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbYHOV6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 17:58:45 -0400
Message-ID: <48A5FBFD.5080501@zytor.com>
Date: Fri, 15 Aug 2008 14:58:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Andy Whitcroft <apw@shadowen.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Possible false positive in checkpatch
References: <Pine.LNX.4.44L0.0808121017510.2509-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0808121017510.2509-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> The following appears to be a false positive in checkpatch:
> 
> ERROR: space prohibited after that '*' (ctx:BxW)
> #163: FILE: drivers/usb/core/usb.c:304:
> +#define usb_device_pm_ops      (* (struct pm_ops *) 0)
>                                  ^
> 
> Certainly this is a rather uncommon code construction, but similar
> ones might occur elsewhere.  To my eyes,
> 
> 	(* (type *) ptr)
> 
> looks better than
> 
> 	(*(type *) ptr)
> 
> or
> 
> 	(*(type *)ptr)
> 
> or even
> 
> 	(*(type*)ptr)
> 
> but of course this is a matter of opinion.  Is there any strong feeling 
> about this in the kernel community?
> 

Personally, I rather strongly prefer (*(type *)ptr).

	-hpa
