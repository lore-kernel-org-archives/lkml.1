Return-Path: <linux-kernel-owner+w=401wt.eu-S933124AbYAYIqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933124AbYAYIqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:46:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765863AbYAYIZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:25:30 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:54409 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765782AbYAYIZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 03:25:28 -0500
Message-ID: <47999CF2.9070805@garzik.org>
Date: Fri, 25 Jan 2008 03:25:22 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Mike Halcrow <mhalcrow@us.ibm.com>,
       Phillip Hellewell <phillip@hellewell.homeip.net>
Subject: Re: [PATCH 076/196] ecryptfs: remove version_str file from sysfs
References: <20080125071127.GA4860@kroah.com> <1201245134-4876-76-git-send-email-gregkh@suse.de>
In-Reply-To: <1201245134-4876-76-git-send-email-gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman wrote:
> This file violates the one-value-per-file sysfs rule.
> 
> If you all want it added back, please do something like a per-feature
> file to show what is present and what isn't.
> 
> Cc: Kay Sievers <kay.sievers@vrfy.org>
> Cc: Mike Halcrow <mhalcrow@us.ibm.com>
> Cc: Phillip Hellewell <phillip@hellewell.homeip.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  fs/ecryptfs/main.c |   43 -------------------------------------------
>  1 files changed, 0 insertions(+), 43 deletions(-)

It's not really good policy to rip out ABIs found in release kernels 
like this, even if the motivation is sound.

IMO "don't break ABIs" rule is far more important than a 
one-value-per-file sysfs rule.

	Jeff



