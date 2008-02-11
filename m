Return-Path: <linux-kernel-owner+w=401wt.eu-S1760572AbYBKTbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760572AbYBKTbZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 14:31:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758104AbYBKTbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 14:31:15 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:55279 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756634AbYBKTbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 14:31:14 -0500
Message-ID: <47B0A27F.90401@garzik.org>
Date: Mon, 11 Feb 2008 14:31:11 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Saeed Bishara <saeed@marvell.com>
Subject: Re: [PATCH] sata_mv: fix loop with last port
References: <200802071506.17459.yinghai.lu@sun.com>
In-Reply-To: <200802071506.17459.yinghai.lu@sun.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> [PATCH] sata_mv: fix loop with last port
> 
> commit f351b2d638c3cb0b95adde3549b7bfaf3f991dfa
>         sata_mv: Support SoC controllers
> 
> cause panic:
[...]
> last_port already include port0 base.
> this patch change use last_port directly, and move pp assignment later.
> 
> Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

applied

Please don't repeat the email subject line in the email body, as that 
causes it to be duplicated in the permanent kernel changelog.

