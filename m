Return-Path: <linux-kernel-owner+w=401wt.eu-S1758283AbZJOHxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283AbZJOHxt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 03:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755286AbZJOHxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 03:53:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5774 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755217AbZJOHxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 03:53:48 -0400
Message-ID: <4AD6D583.7080301@redhat.com>
Date: Thu, 15 Oct 2009 15:55:47 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, Krzysztof Piotr Oledzki <ole@ans.pl>
Subject: Re: [Patch] netfilter: remove deprecated CONFIG_NF_CT_ACCT
References: <20091015075127.4529.74106.sendpatchset@localhost.localdomain>
In-Reply-To: <20091015075127.4529.74106.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amerigo Wang wrote:
> CONFIG_NF_CT_ACCT is scheduled to be removed in 2.6.29.
> 
> Cc: Krzysztof Piotr Oledzki <ole@ans.pl>
> Signed-off-by: WANG Cong <amwang@redhat.com>
> 
> ---
> diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
> index 04e6c81..3170c85 100644
> --- a/Documentation/feature-removal-schedule.txt
> +++ b/Documentation/feature-removal-schedule.txt
> @@ -345,15 +345,6 @@ Who:	Johannes Berg <johannes@sipsolutions.net>
>  
>  ---------------------------
>  
> -What: CONFIG_NF_CT_ACCT
> -When: 2.6.29
> -Why:  Accounting can now be enabled/disabled without kernel recompilation.
> -      Currently used only to set a default value for a feature that is also
> -      controlled by a kernel/module/sysfs/sysctl parameter.
> -Who:  Krzysztof Piotr Oledzki <ole@ans.pl>
> -
> ----------------------------
> -
>  What:	sysfs ui for changing p4-clockmod parameters
>  When:	September 2009
>  Why:	See commits 129f8ae9b1b5be94517da76009ea956e89104ce8 and
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 9107b38..27df05b 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1534,7 +1534,6 @@ and is between 256 and 4096 characters. It is defined in the file
>  			[NETFILTER] Enable connection tracking flow accounting
>  			0 to disable accounting
>  			1 to enable accounting
> -			Default value depends on CONFIG_NF_CT_ACCT that is
>  			going to be removed in 2.6.29.


Oops! sed made this wrong here. Sorry.

I will update this patch...
