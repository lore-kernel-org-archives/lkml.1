Return-Path: <linux-kernel-owner+w=401wt.eu-S1758032AbXGTLrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032AbXGTLrU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 07:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754180AbXGTLrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 07:47:01 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49753 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727AbXGTLrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 07:47:00 -0400
Message-ID: <46A0A0B2.2010902@garzik.org>
Date: Fri, 20 Jul 2007 07:46:58 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Magnus Damm <magnus.damm@gmail.com>
CC: linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: pata_platform: Fix NULL pointer dereference
References: <20070720035058.25300.28389.sendpatchset@clockwork.opensource.se>
In-Reply-To: <20070720035058.25300.28389.sendpatchset@clockwork.opensource.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Magnus Damm wrote:
> pata_platform: Fix NULL pointer dereference
> 
> pata_platform currently dereferences a NULL pointer in pata_platform_probe()
> if pdev->dev.platform_data is set to NULL. This breakage was most likely
> introduced by commit 5f45bc50976ee1f408f7171af155aec646655a37.
> 
> Signed-off-by: Magnus Damm <damm@igel.co.jp>
> ---
> 
>  Tested on a Solution Engline 7722 board, fixes NULL dereference problem.
>  Applies to linux-2.6 git 9a79b2274186fade17134929d4f85b70d59a3840
>  Could someone please make sure this gets included in rc1?
> 
>  drivers/ata/pata_platform.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

applied


