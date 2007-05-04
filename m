Return-Path: <linux-kernel-owner+w=401wt.eu-S1161603AbXEDStb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161603AbXEDStb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 14:49:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161605AbXEDStb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 14:49:31 -0400
Received: from mta11.adelphia.net ([68.168.78.205]:64252 "EHLO
	mta11.adelphia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161603AbXEDSta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 14:49:30 -0400
Message-ID: <463B8037.70701@acm.org>
Date: Fri, 04 May 2007 13:49:27 -0500
From: Corey Minyard <minyard@acm.org>
User-Agent: Icedove 1.5.0.10 (X11/20070328)
MIME-Version: 1.0
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH (trivial)] Fix wrong identifier name in Documentation/kref.txt
References: <Pine.LNX.4.64.0705041949130.14683@cselinux1.cse.iitk.ac.in>
In-Reply-To: <Pine.LNX.4.64.0705041949130.14683@cselinux1.cse.iitk.ac.in>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, please add this.  Thanks.

-corey

Satyam Sharma wrote:
> Here's another trivial one I've been meaning to send since ... a long 
> time back.
>
> Cheers,
> Satyam
>
> ---
>
> There's a typo / wrong identifier name in Documentation/kref.txt. Fix it.
>
>     Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
>
> ---
>
> diff -ruNp linux-2.6.21.1/Documentation/kref.txt 
> linux-2.6.21.1~patch/Documentation/kref.txt
> --- linux-2.6.21.1/Documentation/kref.txt    2007-05-04 
> 19:40:01.000000000 +0530
> +++ linux-2.6.21.1~patch/Documentation/kref.txt    2007-05-04 
> 19:41:04.000000000 +0530
> @@ -67,7 +67,7 @@ void more_data_handling(void *cb_data)
>      .
>      . do stuff with data here
>      .
> -    kref_put(data, data_release);
> +    kref_put(&data->refcount, data_release);
>  }
>
>  int my_data_handler(void)

