Return-Path: <linux-kernel-owner+w=401wt.eu-S1758340AbYG0PwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758340AbYG0PwU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 11:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbYG0PwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 11:52:07 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:17764 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993AbYG0PwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 11:52:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tVomSmRARRZyLKp+FB3dipdZXKKSi+sjoZPlwlk2NyFdlm5Z8WJGjM4YsW87EjelqW
         QvqRKiWlUypW14xeTetq3egUHe+wnHy2Td0FicPIqGtHg9ET/e8I0e6bD24LJ+JRb0uA
         BBxCwekU4fH2Hc5FvHEQoF3jDkkbW9j4jMJlI=
Date: Sun, 27 Jul 2008 19:52:02 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Niels de Vos <niels@nixpanic.net>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RESEND] [PATCH] linux/fs.h should include linux/path.h
Message-ID: <20080727155202.GA5454@martell.zuzino.mipt.ru>
References: <488C6B4E.8040205@nixpanic.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488C6B4E.8040205@nixpanic.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 27, 2008 at 02:34:22PM +0200, Niels de Vos wrote:
> <linux/fs.h> defines 'struct file' which uses 'struct path'. However
> <linux/path.h> is not being included.

> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -289,6 +289,7 @@ extern int dir_notify_enable;
>  #include <linux/mutex.h>
>  #include <linux/capability.h>
>  #include <linux/semaphore.h>
> +#include <linux/path.h>

You see compilation breakage?

