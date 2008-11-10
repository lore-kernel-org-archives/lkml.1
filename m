Return-Path: <linux-kernel-owner+w=401wt.eu-S1754694AbYKJJAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694AbYKJJAb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 04:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754025AbYKJJAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 04:00:21 -0500
Received: from gw-ca.panasas.com ([66.104.249.162]:2696 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750970AbYKJJAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 04:00:20 -0500
Message-ID: <4917F82D.2080307@panasas.com>
Date: Mon, 10 Nov 2008 11:00:29 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird/3.0a2 (X11; 2008072418)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Sam Ravnborg <sam@ravnborg.org>,
       open-osd development <osd-dev@open-osd.org>,
       Mike Christie <michaelc@cs.wisc.edu>,
       linux-scsi <linux-scsi@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       Sami.Iren@seagate.com, linux-kernel <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [osd-dev] [PATCH 04/18] libosd: OSDv1 preliminary implementation
References: <491073BB.4000900@panasas.com>	<1225817069-5969-1-git-send-email-bharrosh@panasas.com>	<20081104180347.GA9818@uranus.ravnborg.org> <49119BAF.6040603@panasas.com> <4916F9F5.9040409@panasas.com> <4917C89A.70909@oracle.com>
In-Reply-To: <4917C89A.70909@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Nov 2008 08:58:57.0955 (UTC) FILETIME=[91189730:01C94312]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> Boaz Harrosh wrote:
>> Boaz Harrosh wrote:
>>> Sam Ravnborg wrote:
>>>>> +EXPORT_SYMBOL(osd_dev_init);
>>>> kernel-doc comments for all exported funtions / variables.
>>>>
>>> I have some kernel-doc comments of exported functions in the Header
>>> file. I have not yet finished all of them. (Laziness on my part).
>>>
>>> Are kernel-doc comments in headers a big NO-NO. I like it this way,
>>> so when I have to learn a new Library all the information
>>> I need to know is in the header. Also the header is a much better place
>>> when you do programing by shopping, that is you don't know what you need
>>> and you look for what's available.
>>>
>>> Thanks
>>> Boaz
>> Sam please comment if kernel-doc comments are OK in headers
> 
> Hi,
> 
> The de facto standard for kernel-doc comments is at the implementation site,
> which means normally in .c files, except for macros or inline functions.
> 
> Sure you can find some exceptions to that.  And there is no hard requirement
> in Documentation/kernel-doc-nano-HOWTO.txt.
> 
> IMO the biggest concern is making sure that the (kernel-doc) comments are
> updated when the function implementation changes (if updates are needed).
> Where would be the best place for this to be more likely to happen?
> Usually at the function implementation, I would say.
> 
> ~Randy
> 
> 
Thanks Randy

I would like to keep them in the Headers then. This is because I make
sure that the implementation includes the declaring header, so any miss-matches
are caught by the compiler. 
And because these are all library routines exported to other modules. The important
thing is the API you linked with. If the API/parametrization change it must first
change in the header. The internal implementation is not documented only the external
black-box functionality is documented in these places.

I will think about it some more, but for now, if it's OK I would like to keep them
like submitted. In this particular library they make more sense to me in the header.

Boaz
