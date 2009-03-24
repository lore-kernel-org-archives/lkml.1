Return-Path: <linux-kernel-owner+w=401wt.eu-S1753573AbZCXVX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573AbZCXVX6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 17:23:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167AbZCXVXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 17:23:48 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59998 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751374AbZCXVXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 17:23:47 -0400
Date: Tue, 24 Mar 2009 21:24:45 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: stoyboyker@gmail.com
Cc: linux-kernel@vger.kernel.org, Stoyan Gaydarov <stoyboyker@gmail.com>,
       linux-media@vger.kernel.org
Subject: Re: [PATCH 12/13] [drivers/media] changed ioctls to unlocked
Message-ID: <20090324212445.224fd377@lxorguk.ukuu.org.uk>
In-Reply-To: <1237929168-15341-13-git-send-email-stoyboyker@gmail.com>
References: <1237929168-15341-13-git-send-email-stoyboyker@gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -static int dabusb_ioctl (struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
> +static long dabusb_ioctl (struct file *file, unsigned int cmd, unsigned long arg)
>  {
> +	lock_kernel();
>  	pdabusb_t s = (pdabusb_t) file->private_data;

After the variables or you'll get lots of warnings from gcc

