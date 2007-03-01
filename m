Return-Path: <linux-kernel-owner+w=401wt.eu-S965551AbXCAT5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965551AbXCAT5X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 14:57:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965552AbXCAT5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 14:57:22 -0500
Received: from warden-p.diginsite.com ([208.29.163.248]:47945 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S965551AbXCAT5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 14:57:21 -0500
Date: Thu, 1 Mar 2007 11:37:59 -0800 (PST)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: Johann Borck <johann.borck@densedata.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
In-Reply-To: <45E7287D.7000104@densedata.com>
Message-ID: <Pine.LNX.4.63.0703011136570.23701@qynat.qvtvafvgr.pbz>
References: <20070222074044.GA4158@elte.hu>  <20070222113148.GA3781@2ka.mipt.ru>
  <Pine.LNX.4.64.0702251428490.12485@woody.linux-foundation.org> 
 <20070226172812.GC22454@2ka.mipt.ru>  <Pine.LNX.4.64.0702260938450.12485@woody.linux-foundation.org>
  <20070226195416.GA11188 <20070301081808.GD7217@2ka.mipt.ru>
 <45E7287D.7000104@densedata.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 1 Mar 2007, Johann Borck wrote:

> I reported this a while ago and suggested to have the number of pending 
> accepts reported with the event to save that last syscall.
> I  created an ab replacement based on kevent, and at least with my machines, 
> which are comparable to each other, the load on client dropped from 100% to 
> 2% or something. ab just doesn't give meaningful results  (if the client is 
> not way more powerful). With that new client I get very similar results for 
> epoll and kevent, from 1000 through to 26000 concurrent requests, the results 
> have been posted on kevent-homepage in october, I just checked it with new 
> version, but there's no significant difference.
>
> this is the benchmark with kevent-based client:
> http://tservice.net.ru/~s0mbre/blog/2006/10/11#2006_10_11
> btw, each result is average over 1,000,000 requests
>
> and just for comparison, this is on the same machines using ab:
> http://tservice.net.ru/~s0mbre/blog/2006/10/08#2006_10_08

is this client avaialble? and what patches need to be added to the kernel to use 
it?

David Lang
