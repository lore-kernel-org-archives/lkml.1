Return-Path: <linux-kernel-owner+w=401wt.eu-S939106AbXHIJrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939106AbXHIJrq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 05:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935303AbXHIJrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 05:47:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765022AbXHIJrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 05:47:19 -0400
Message-ID: <46BAE29A.6010803@redhat.com>
Date: Thu, 09 Aug 2007 05:47:06 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Chris Holvenstot <saltydog@houston.rr.com>
CC: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Kernel / Fliesystem Error
References: <1186623555.6613.17.camel@localhost>
In-Reply-To: <1186623555.6613.17.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Holvenstot wrote:
> I think that I may have spotted a minor bug in the 2.6.23 kernel and its
> relationship with the EXT3 file system.  I apologize in advance if I am
> mistaken, reporting a problem that is already known (I did not spot it
> in Bugzilla) or if I am reporting it to the wrong forum.  I made the
> decision a just a few weeks ago to participate by running my system on
> the newest kernels and this is the first issue I have attempted to
> report.
> 
> And I know that you have stumble a few times before you get the hang of
> it.
> 
> I note that on the 2.6.23-rc1, rc2 and rc2-git1 systems that when I boot
> I receive the following message each and every time:
> 
> /dev/sda1:  Superblock last write time is in the future.  FIXED

The problem here is that your clock is wrong either at mount (boot) time or 
unmount (shutdown) time.  There's nothing wrong with ext3, except that it 
happens to be noticing this condition.

	-- Chris
