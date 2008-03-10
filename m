Return-Path: <linux-kernel-owner+w=401wt.eu-S1756187AbYCJXnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187AbYCJXnt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 19:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751085AbYCJXnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 19:43:42 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36952 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbYCJXnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 19:43:41 -0400
Message-ID: <47D5C796.1080302@cn.fujitsu.com>
Date: Tue, 11 Mar 2008 08:43:18 +0900
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] cgroup: switch to proc_create()
References: <47D4E3AC.2020600@cn.fujitsu.com> <6599ad830803101401s3b12bc85l53ef67f083ad761c@mail.gmail.com>
In-Reply-To: <6599ad830803101401s3b12bc85l53ef67f083ad761c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Mon, Mar 10, 2008 at 12:30 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>> There is a race between create_proc_entry() and the assignment
>>  of file ops. proc_create() is invented to fix it.
>>
>>  Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> Acked-by: Paul Menage <menage@google.com>
> 
> Doesn't seem to be a serious race since there's nothing in userspace
> at this point to read the file. But replacing four lines with one is
> generally a good thing.
> 

Yes I know, it's a slight race in case of modular code, but the aim is 
to replace all the use of create_proc_entry() with proc_create(). :) 

> Paul
> 
