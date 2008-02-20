Return-Path: <linux-kernel-owner+w=401wt.eu-S1758627AbYBTQvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758627AbYBTQvv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 11:51:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756163AbYBTQvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 11:51:40 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:48825 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757201AbYBTQvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 11:51:37 -0500
Message-ID: <47BC5A94.8060908@garzik.org>
Date: Wed, 20 Feb 2008 11:51:32 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Leonardo Potenza <lpotenza@inwind.it>
CC: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net/cs89x0.c: compilation warning fix
References: <200802171823.15759.lpotenza@inwind.it>
In-Reply-To: <200802171823.15759.lpotenza@inwind.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Leonardo Potenza wrote:
> From: Leonardo Potenza <lpotenza@inwind.it>
> 
> Suppress the warning message about the 'netcard_portlist' defined but not used.
> 
> Signed-off-by: Leonardo Potenza <lpotenza@inwind.it>
> ---
> 
> When building cs89x0 as a module, the following warning message is generated:
> drivers/net/cs89x0.c:198: warning: 'netcard_portlist' defined but not used
> 
> Since the netcard_portlist is not so big, I just marked the array as __used.

applied


