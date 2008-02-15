Return-Path: <linux-kernel-owner+w=401wt.eu-S932995AbYBOOq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932995AbYBOOq4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 09:46:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755909AbYBOOqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 09:46:49 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:57882 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560AbYBOOqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 09:46:48 -0500
Date: Fri, 15 Feb 2008 15:46:47 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, mpm@selenic.com
Subject: Re: [PATCH] Use directly kmalloc() and kfree() in init/initramfs.c
In-Reply-To: <20080215121330.3f790783@crazy>
Message-ID: <Pine.LNX.4.64.0802151546230.30301@fbirervta.pbzchgretzou.qr>
References: <20080215121330.3f790783@crazy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 15 2008 12:13, Thomas Petazzoni wrote:
>+++ linux/init/initramfs.c
>@@ -57,7 +57,7 @@
> 			continue;
> 		return (*p)->name;
> 	}
>-	q = (struct hash *)malloc(sizeof(struct hash));
>+	q = (struct hash *)kmalloc(sizeof(struct hash), GFP_KERNEL);

Remove the cast while you are at it, thanks :)

