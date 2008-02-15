Return-Path: <linux-kernel-owner+w=401wt.eu-S1757278AbYBOQAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278AbYBOQAo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 11:00:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752971AbYBOQAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 11:00:37 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:50212 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbYBOQAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 11:00:36 -0500
Date: Fri, 15 Feb 2008 17:00:35 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, mpm@selenic.com
Subject: Re: [PATCH] Use directly kmalloc() and kfree() in init/initramfs.c
In-Reply-To: <20080215164503.245752e6@crazy>
Message-ID: <Pine.LNX.4.64.0802151658320.30301@fbirervta.pbzchgretzou.qr>
References: <20080215121330.3f790783@crazy> <Pine.LNX.4.64.0802151546230.30301@fbirervta.pbzchgretzou.qr>
 <20080215164503.245752e6@crazy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 15 2008 16:45, Thomas Petazzoni wrote:
>
>> Remove the cast while you are at it, thanks :)
>
>Right, thanks for the comment. Here is an updated patch. Who will pick
>it up ? There doesn't seem to be a maintainer for the initramfs code
>(not in MAINTAINERS, not in the init/initramfs.c file itself).

Anyone you can get to push the actual changeset; many won't feel
responsible :) so the path is through ->akpm->linus here.

BTW, if you changed free to kfree, did the free macro/whatever get 
removed or is it still used?
