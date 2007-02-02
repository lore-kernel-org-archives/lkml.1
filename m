Return-Path: <linux-kernel-owner+w=401wt.eu-S1945982AbXBBQyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945982AbXBBQyy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 11:54:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945983AbXBBQyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 11:54:54 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:49915 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945982AbXBBQyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 11:54:46 -0500
Message-ID: <45C36CD4.1010809@garzik.org>
Date: Fri, 02 Feb 2007 11:54:44 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Alan <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH] libata: Fix (hopefully) all the remaining problems with
 devices failing setup/identify
References: <20070131172605.2c5dfc78@localhost.localdomain>	<45C0D050.4030302@garzik.org> <20070131174724.7b17153a@localhost.localdomain>
In-Reply-To: <20070131174724.7b17153a@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan wrote:
>> Looks like you should use ata_busy_wait() here, rather than reproducing 
>> the same code again.
> 
> It waits in 10uS chunks while 1uS chunks were used in the workaround.
> Could indeed do that once I know the fix is right. While I'm at it the
> ata_busy_wait kerneldoc is borked so here's a fix
> 
> Signed-off-by: Alan Cox <alan@redhat.com>

applied

