Return-Path: <linux-kernel-owner+w=401wt.eu-S1751249AbYEHUXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751249AbYEHUXn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 16:23:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756020AbYEHUX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 16:23:27 -0400
Received: from smtp-out.google.com ([216.239.33.17]:34017 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755911AbYEHUXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 16:23:25 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=mLyZPXFoaLkcEu16cG9AB8UW02x/gTGIXAfVU7RxaA0zW7629JXkGww4PHLsinsQK
	9J4fUg8lizcMK9wMsKcDw==
Message-ID: <6599ad830805081323h52f38e21i1d98bdbf4a594d06@mail.gmail.com>
Date: Thu, 8 May 2008 13:23:20 -0700
From: "Paul Menage" <menage@google.com>
To: "Dhaval Giani" <dhaval@linux.vnet.ibm.com>
Subject: Re: [PATCH] fix cgroups documentation
Cc: nikhil.john@yahoo.com, "Sudhir Kumar" <skumar@linux.vnet.ibm.com>,
       "Balbir Singh" <balbir@in.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20080508105903.GA3870@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080508105903.GA3870@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 8, 2008 at 3:59 AM, Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> Just correcting the cgroups documentation to reflect the correct file names.
>
> Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>

Acked-by: Paul Menage <menage@google.com>

>
> Index: linux-2.6/Documentation/cgroups.txt
> ===================================================================
> --- linux-2.6.orig/Documentation/cgroups.txt    2008-04-30 14:42:05.000000000 +0530
> +++ linux-2.6/Documentation/cgroups.txt 2008-05-08 16:26:58.000000000 +0530
> @@ -310,8 +310,8 @@ and then start a subshell 'sh' in that c
>   cd /dev/cgroup
>   mkdir Charlie
>   cd Charlie
> -  /bin/echo 2-3 > cpus
> -  /bin/echo 1 > mems
> +  /bin/echo 2-3 > cpuset.cpus
> +  /bin/echo 1 > cpuset.mems
>   /bin/echo $$ > tasks
>   sh
>   # The subshell 'sh' is now running in cgroup Charlie
>
> --
> regards,
> Dhaval
>
