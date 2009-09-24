Return-Path: <linux-kernel-owner+w=401wt.eu-S1753249AbZIXQDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbZIXQDY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 12:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753115AbZIXQDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 12:03:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30803 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752825AbZIXQDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 12:03:23 -0400
Message-ID: <4ABB99FE.3060105@redhat.com>
Date: Thu, 24 Sep 2009 19:10:38 +0300
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, aarcange@redhat.com
Subject: Re: [PATCH] ksm: change default values to better fit into mainline
 kernel
References: <1253736347-3779-1-git-send-email-ieidus@redhat.com> <Pine.LNX.4.64.0909241644110.16561@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0909241644110.16561@sister.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2009 06:52 PM, Hugh Dickins wrote:
> You rather caught me by surprise with this one, Izik: I was thinking
> more rc7 than rc1 for switching it off;

I thought that after the merge window -> only fixes can get in, but I 
guess I was wrong...

> +#else
> +	ksm_run = KSM_RUN_MERGE;	/* no way for user to start it */
> +
>    

That is a good point, didnt notice that I am blocking the usage of it 
when sysfs is not build.

>   #endif /* CONFIG_SYSFS */
>
>   	return 0;
>    

