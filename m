Return-Path: <linux-kernel-owner+w=401wt.eu-S1751400AbZGMF2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400AbZGMF2k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 01:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750801AbZGMF2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 01:28:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64832 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750753AbZGMF2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 01:28:35 -0400
Message-ID: <4A5AC5F5.5050206@cn.fujitsu.com>
Date: Mon, 13 Jul 2009 13:28:21 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Alan Stern <stern@rowland.harvard.edu>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hw_breakpoint: remove sample code from hw_breakpoint.h
References: <4A52DFBB.7040800@cn.fujitsu.com> <20090707210410.GG6184@nowhere>
In-Reply-To: <20090707210410.GG6184@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(sorry for the late reply, I didn't see this mail..)

Frederic Weisbecker wrote:
> On Tue, Jul 07, 2009 at 01:40:11PM +0800, Li Zefan wrote:
>> The sample code is a bit out-dated, and there's already a
>> sample in sample/hw_breakpoint/.
> 
> 
> IMHO these bits of comments are useful and don't overlap the role
> of the samples in sample/
> They only stand there as a quick summup.
> 
> No?
> 

The sample here sets a breakpoint on pid_max, which is what the sample
in sample/ does.

And the code here is out-dated (and incomplete). We can fix it, but
whenver someone changes the APIs, he may forget to update the comments.
We know comments never catch up with code.

So I inclined to delete it, and add a link to sample/.



