Return-Path: <linux-kernel-owner+w=401wt.eu-S1756019AbZBZF3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019AbZBZF3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 00:29:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbZBZF3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 00:29:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47106 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbZBZF3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 00:29:44 -0500
Message-ID: <49A62899.4080001@zytor.com>
Date: Wed, 25 Feb 2009 21:28:57 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Harvey Harrison <harvey.harrison@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] introduce pr_cont macro
References: <20090225205920.GA22091@localhost> <20090226030315.GB7526@elte.hu> <1235617541.5610.0.camel@brick> <20090226031301.GE7526@elte.hu> <1235618574.5610.1.camel@brick> <20090226032544.GB22223@elte.hu>
In-Reply-To: <20090226032544.GB22223@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> Btw., why do those macros use ##__VA_ARGS__ ? Why not a 
> straightforward:
> 
>  #define __pr_cont(args...) \
>  	printk(KERN_CONT args)
> 

Don't know if anyone cares, but __VA_ARGS__ is C99 whereas args... is a 
gcc extension, AFAIK.

	-hpa

