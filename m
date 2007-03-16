Return-Path: <linux-kernel-owner+w=401wt.eu-S2992465AbXCPAmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992465AbXCPAmz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 20:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992464AbXCPAmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 20:42:55 -0400
Received: from terminus.zytor.com ([192.83.249.54]:48926 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992445AbXCPAmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 20:42:54 -0400
Message-ID: <45F9E806.2010405@zytor.com>
Date: Thu, 15 Mar 2007 17:42:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: alon.barlev@gmail.com, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [REPOST] x86_64, i386: Add command line length to boot
 protocol
References: <20070315210516.GA28998@strauss.suse.de>
In-Reply-To: <20070315210516.GA28998@strauss.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bernhard Walle wrote:
> Because the command line is increased to 2048 characters after 2.6.21,
> it's not possible for boot loaders and userspace tools to determine the length
> of the command line the kernel can understand. The benefit of knowing the
> length is that users can be warned if the command line size is too long which
> prevents surprise if things don't work after bootup.
> 
> This patch updates the boot protocol to contain a field called
> "cmdline_size" that contain the length of the command line (excluding
> the terminating zero).
> 
> The patch also adds missing fields (of protocol version 2.05) to the x86_64
> setup code.
> 
> 
> Signed-off-by: Bernhard Walle <bwalle@suse.de>
> Cc: Alon Bar-Lev <alon.barlev@gmail.com>

Acked-by: H. Peter Anvin <hpa@zytor.com>
