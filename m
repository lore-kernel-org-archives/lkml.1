Return-Path: <linux-kernel-owner+w=401wt.eu-S1757130AbYDMJQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130AbYDMJQT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 05:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754621AbYDMJQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 05:16:08 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36602 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753666AbYDMJQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 05:16:07 -0400
Date: Sun, 13 Apr 2008 10:11:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, Bob Copeland <me@bobcopeland.com>
Subject: Re: [PATCH 3/7] omfs: add directory routines
Message-ID: <20080413101144.4d496e9d@core>
In-Reply-To: <1208041121-26787-4-git-send-email-me@bobcopeland.com>
References: <1208041121-26787-4-git-send-email-me@bobcopeland.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +static int omfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
> +{
> +	struct inode *dir = filp->f_dentry->d_inode;
> +	struct buffer_head *bh = NULL;

> +	if (filp->f_pos >> 32)
> +		goto success;

f_pos may be 32bit in which case >> 32 does not have defined behaviour in
C.


Alan
