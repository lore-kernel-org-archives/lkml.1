Return-Path: <linux-kernel-owner+w=401wt.eu-S1759790AbXEOQ5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759790AbXEOQ5j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 12:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755657AbXEOQ5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 12:57:33 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:48314 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755298AbXEOQ5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 12:57:32 -0400
Message-ID: <4649E680.9020102@cfl.rr.com>
Date: Tue, 15 May 2007 12:57:36 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Dong Feng <middle.fengdong@gmail.com>
CC: pradeep singh <2500.pradeep@gmail.com>,
       Bahadir Balban <bahadir.balban@gmail.com>,
       Learning Linux <learninglinux4@gmail.com>, kernelnewbies@nl.linux.org,
       linux-newbie@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Why can't we sleep in an ISR?
References: <9f1dc2cf0705132337k13aa3ccesc575d4550492a24e@mail.gmail.com>  <366312910705140010m78b215a2t1753445e81120288@mail.gmail.com>  <9f1dc2cf0705140016w6d8f44f9wec7586e7879af873@mail.gmail.com>  <7ac1e90c0705140824i54e1c43ela3ab3d89827c0339@mail.gmail.com>  <3 <a2ebde260705142345m440c70fbu33934334fbb69f8e@mail.gmail.com>
In-Reply-To: <a2ebde260705142345m440c70fbu33934334fbb69f8e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 May 2007 16:57:43.0327 (UTC) FILETIME=[279EC2F0:01C79712]
X-TM-AS-Product-Ver: SMEX-7.2.0.1122-3.6.1039-15176.003
X-TM-AS-Result: No--1.716800-5.000000-31
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dong Feng wrote:
>> Doesn't it run in current process's context ?
>>
> 
> No. I think the concept of process context is a higher-level logical
> concept. Though the interrupt share stack with the interrupted
> process, in my opinion it logically does not share the context with
> the process.

No, the term context here has a specific meaning.  It refers to those 
things which flow from the current pointer, including the virtual memory 
space, file descriptor table, current uid, and so forth.  Because the 
current pointer is not changed on entry to an ISR, the ISR is executing 
in the context of the interrupted process, and thus uses that process' 
virtual memory, etc.


