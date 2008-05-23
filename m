Return-Path: <linux-kernel-owner+w=401wt.eu-S1764402AbYEWDE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764402AbYEWDE7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 23:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760638AbYEWDEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 23:04:49 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:43949 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760603AbYEWDEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 23:04:49 -0400
Date: Fri, 23 May 2008 13:04:42 +1000
From: Stephen Rothwell <sfr@au1.ibm.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] viotape: Push down BKL ioctls
Message-Id: <20080523130442.54034a2f.sfr@au1.ibm.com>
In-Reply-To: <20080522222012.3a07bd57@core>
References: <20080522222012.3a07bd57@core>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Thu, 22 May 2008 22:20:12 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>
> -static int viotap_ioctl(struct inode *inode, struct file *file,
> -		unsigned int cmd, unsigned long arg)
> +static long viotap_ioctl(struct file *file, unsigned int cmd,
> +							unsigned long arg)

The inode parameter is used in this function (so it won't build after
this patch) but in a weird way.   I will do an alternate patch.

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
