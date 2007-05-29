Return-Path: <linux-kernel-owner+w=401wt.eu-S1759646AbXE2Q5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759646AbXE2Q5W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 12:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbXE2Q5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 12:57:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43972 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180AbXE2Q5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 12:57:15 -0400
Message-ID: <465C5B61.6000702@redhat.com>
Date: Tue, 29 May 2007 12:57:05 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Bill Davidsen <davidsen@tmr.com>
CC: Linux Kernel mailing List <linux-kernel@vger.kernel.org>
Subject: Re: What causes iowait other than waiting for i/o?
References: <465B4B75.2040602@tmr.com>
In-Reply-To: <465B4B75.2040602@tmr.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Davidsen wrote:
> I recently noted that my system was spending a lot of time in i/o wait 
> when doing some tasks which I thought didn't involve i/o, as noted by 
> the lack of disk light activity most of the time. I thought of network, 
> certainly the NIC had no activity for this job. So I set up a little 
> loop to capture all disk i/o and network activity (including loopback). 
> That was no obvious help, and the program doesn't use pipes.
> 
> At this point I'm really curious, does someone have a good clue?
> 
> Note: I don't think this is a bug or performance issue, unless the 
> kernel is doing something and charging time to iowait instead of system 
> I don't see anything to fix, but I would like to understand.

All filesystem IO and direct disk IO can cause iowait.

This includes NFS activity.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
