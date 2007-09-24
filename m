Return-Path: <linux-kernel-owner+w=401wt.eu-S1759478AbXIXNVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759478AbXIXNVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 09:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbXIXNVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 09:21:41 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:43964 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbXIXNVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 09:21:41 -0400
Message-ID: <46F7B9C6.4000901@linux.vnet.ibm.com>
Date: Mon, 24 Sep 2007 18:51:10 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Pavel Emelyanov <xemul@openvz.org>
CC: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc7-mm1
References: <20070924021716.9bfe7dfb.akpm@linux-foundation.org> <46F7B3B3.7010600@linux.vnet.ibm.com> <46F7B737.4020001@openvz.org>
In-Reply-To: <46F7B737.4020001@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelyanov wrote:
> Please, try with this patch too:
> 
> diff --git a/fs/locks.c b/fs/locks.c
> index c0fe71a..f599508 100644
> --- a/fs/locks.c
> +++ b/fs/locks.c
> @@ -1423,7 +1423,7 @@ int generic_setlease(struct file *filp, 
>  	locks_copy_lock(new_fl, lease);
>  	locks_insert_lock(before, new_fl);
> 
> -	*flp = fl;
> +	*flp = new_fl;
>  	return 0;
> 
>  out:
> 

Hi, Pavel,

You did not signoff on the patch.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
