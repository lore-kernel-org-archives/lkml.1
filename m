Return-Path: <linux-kernel-owner+w=401wt.eu-S971876AbXHMM2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971876AbXHMM2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968082AbXHMGvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:51:43 -0400
Received: from smtpserver.stunet.se ([85.194.0.110]:60796 "EHLO mail.visit.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968138AbXHMGvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:51:41 -0400
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKOEHMGBAC.davids@webmaster.com>
References: <MDEHLPKNGKAHNMBLJOLKOEHMGBAC.davids@webmaster.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
X-Priority: 3 (Normal)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <5E4153F3-80E6-4425-A5C8-47E29A549030@nocrew.org>
Cc: <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Fredrik Noring <noring@nocrew.org>
Subject: Re: Improving read/write/close system call reliability when used with pthreads
Date: Mon, 13 Aug 2007 08:50:39 +0200
To: davids@webmaster.com
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David,

True. Even though there is a point in making the kernel detect and  
behave consistently in this case applications (often) end up with  
their own mess they cannot easily handle. A few more use cases would  
now work OK but probably not enough to make the improvement worthwhile.

Thanks,
Fredrik

13 aug 2007 kl. 05.14 skrev David Schwartz:
> Since there's no atomic "unlock and read" function, any code that  
> could ever
> close a socket in one thread while another thread is blocked on  
> read might
> call close just before another thread blocks in read. Nothing stops  
> another
> thread from opening something, getting the same file descriptor,  
> and then
> allowing the thread to call "read" on the wrong file descriptor  
> entirely.
>
> Since this can never be made sane in general, I see little point in  
> making
> one variation of what can go wrong a bit saner. It is still  
> irresponsible to
> code like this.
>
> DS
>
>
>

