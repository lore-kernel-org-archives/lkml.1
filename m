Return-Path: <linux-kernel-owner+w=401wt.eu-S1752568AbXDPN3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbXDPN3L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 09:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbXDPN3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 09:29:11 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:51241 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbXDPN3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 09:29:10 -0400
Date: Mon, 16 Apr 2007 14:29:08 +0100 (IST)
From: Mel Gorman <mel@csn.ul.ie>
X-X-Sender: mel@skynet.skynet.ie
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]Fix parsing kernelcore boot option for ia64
In-Reply-To: <20070413140533.A239.Y-GOTO@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0704161428470.6004@skynet.skynet.ie>
References: <20070413140533.A239.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2007, Yasunori Goto wrote:

> Hello.
>
> cmdline_parse_kernelcore() should return the next pointer of boot option
> like memparse() doing. If not, it is cause of eternal loop on ia64 box.
> This patch is for 2.6.21-rc6-mm1.
>
> Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
>

Acked-by: Mel Gorman <mel@csn.ul.ie>
