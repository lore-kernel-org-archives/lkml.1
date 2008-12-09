Return-Path: <linux-kernel-owner+w=401wt.eu-S1755014AbYLISqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014AbYLISqy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 13:46:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754358AbYLISqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 13:46:43 -0500
Received: from mx2.redhat.com ([66.187.237.31]:35668 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754330AbYLISqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 13:46:43 -0500
Message-ID: <493EBD23.3020800@redhat.com>
Date: Tue, 09 Dec 2008 13:46:59 -0500
From: Casey Dahlin <cdahlin@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Scott James Remnant <scott@netsplit.com>
Subject: Re: [RFC PATCH] waitfd: file descriptor to wait on child processes
References: <493EA441.1070706@redhat.com> <20081209170543.59b4fb73@lxorguk.ukuu.org.uk>
In-Reply-To: <20081209170543.59b4fb73@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> prototype for a fourth: waitfd. It pretty much does what the name 
>> suggests: reading from it yields a series of status ints (as would be 
>> written into the second argument of waitpid) for child processes that 
>> have changed state. It takes essentially the same arguments as waitpid 
>> (for now) and supports the same set of features.
>>     
>
> This propogates the fundamental braindamage of waitpid - the fact the
> notification only works on child process trees.
>
> Here is a more elegant suggestion - use epoll, inotify and friends  fully
> on /proc process nodes.
>
> Alan
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   
Last I checked inotify was not supported in /proc, or at least most of 
it. What kind of work load is it to change that?

--CJD
