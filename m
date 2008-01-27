Return-Path: <linux-kernel-owner+w=401wt.eu-S1759088AbYA0Tec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759088AbYA0Tec (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 14:34:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755808AbYA0Tc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 14:32:26 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:9237 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754929AbYA0TcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 14:32:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=OIMq/SCySrm9oENJN19pjLeBNryeOZ2rKmEL0FLCvScS3AiaQcSLRyKhZZm+AJAgDasEPREqo+473pkDbvYk5A2KLJVPv+MLcJaNbldBzml7jzJvf+QAkqtFpCN4F0YaHc8V4IDUvNFneTh39U29ZVC6NiErIEmz4SIuVkYhSzo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 29/32] ide-tape: remove mtio.h related comments
Date: Sun, 27 Jan 2008 19:24:02 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
References: <1201427300-3954-1-git-send-email-petkovbb@gmail.com> <1201427300-3954-24-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1201427300-3954-24-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801271924.02978.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 January 2008, Borislav Petkov wrote:
> From: Borislav Petkov <bbpetkov@yahoo.de>
> 
> Those are already in mtio.h.
> 
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>

applied

> ---
>  drivers/ide/ide-tape.c |   96 +++++++----------------------------------------
>  1 files changed, 15 insertions(+), 81 deletions(-)

[...]

> -static int idetape_chrdev_ioctl (struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
> +static int idetape_chrdev_ioctl(struct inode *inode, struct file *file,
> +		uint cmd, ulong arg)

I undid this change

lets stick to 'unsigned int' and 'unsigned long' like 99% of the kernel code
