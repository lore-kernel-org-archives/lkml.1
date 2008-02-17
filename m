Return-Path: <linux-kernel-owner+w=401wt.eu-S1756535AbYBQKEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535AbYBQKEE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 05:04:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754517AbYBQKDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 05:03:54 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:23505 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590AbYBQKDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 05:03:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=e0TtZJmFHBSfgdAbJnz5qn2Z1FkiMpuDxgIlnhXraAr/QGasTvTMIQWrMDrQFmyFsIMXilp5iV4nWsxYn+rMaFyLpNHx8hlejs+07K3G5E/qo8EIvbm3G9WPyLcRlw/dsgAAAd2PCdM3TeiDRsBsMornIT1JxqgPmB4dqhSX+8o=
Date: Sun, 17 Feb 2008 13:03:47 +0300
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] fs/proc/kmsg.c should #include <linux/proc_fs.h>
Message-ID: <20080217100347.GA6596@martell.zuzino.mipt.ru>
References: <20080217082048.GW3848@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080217082048.GW3848@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2008 at 10:20:48AM +0200, Adrian Bunk wrote:
> Every file should include the headers containing the externs its global 
> code (in this case for struct proc_kmsg_operations).

It should be moved to fs/proc/internal.h to where it belongs.

> --- a/fs/proc/kmsg.c
> +++ b/fs/proc/kmsg.c
> @@ -11,6 +11,7 @@
>  #include <linux/kernel.h>
>  #include <linux/poll.h>
>  #include <linux/fs.h>
> +#include <linux/proc_fs.h>
