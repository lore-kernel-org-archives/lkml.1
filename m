Return-Path: <linux-kernel-owner+w=401wt.eu-S1752780AbYJRGvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbYJRGvL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 02:51:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbYJRGuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 02:50:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60636 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750972AbYJRGuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 02:50:54 -0400
Date: Fri, 17 Oct 2008 23:50:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oliver Bock <bock@tfh-berlin.de>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       xfs-masters@oss.sgi.com, linux-usb@vger.kernel.org
Subject: Re: 2.6.27: "array subscript is above array bounds" warnings
Message-Id: <20081017235046.f3c6c86e.akpm@linux-foundation.org>
In-Reply-To: <48F4FE60.4060102@tfh-berlin.de>
References: <48F4FE60.4060102@tfh-berlin.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc's added)

On Tue, 14 Oct 2008 22:17:36 +0200 Oliver Bock <bock@tfh-berlin.de> wrote:

> Hi all,
> 
> FYI, I just came across the following warnings when compiling 2.6.27 
> (release) using gcc 4.3.2 (Debian 4.3.2-1) on Debian Lenny (i386):
> 
> ----------
> drivers/acpi/tables/tbfadt.c: In function ___acpi_tb_create_local_fadt___:
> include/asm/string_32.h:75: warning: array subscript is above array bounds
> 
> drivers/usb/core/hcd.c: In function ___usb_hcd_poll_rh_status___:
> include/asm/string_32.h:75: warning: array subscript is above array bounds
> 
> fs/xfs/xfs_mount.c: In function ___xfs_mod_sb___:
> fs/xfs/xfs_mount.c:1456: warning: array subscript is above array bounds
> ----------

