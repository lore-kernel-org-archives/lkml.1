Return-Path: <linux-kernel-owner+w=401wt.eu-S932309AbXDBFrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309AbXDBFrJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 01:47:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932315AbXDBFrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 01:47:09 -0400
Received: from smtp.osdl.org ([65.172.181.24]:36552 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932309AbXDBFrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 01:47:07 -0400
Date: Sun, 1 Apr 2007 22:47:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/16] show-partitions-on-mount-error.diff
Message-Id: <20070401224701.66e6bad3.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.61.0704012008590.12316@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0704012008590.12316@yvahk01.tjqt.qr>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Apr 2007 20:15:53 +0200 (MEST) Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:

> 
> Display all possible partitions when the root filesystem is not mounted.
> This helps to track spell'o's and missing drivers.
> 
> From: David Alan Gilbert, http://lkml.org/lkml/2005/2/26/92
> 
> Updated to work with newer kernels.
> 
> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
> 
> +void printk_all_partitions(void)

I made this __init.

