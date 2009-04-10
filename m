Return-Path: <linux-kernel-owner+w=401wt.eu-S936928AbZDJATq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936928AbZDJATq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 20:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762745AbZDJATh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 20:19:37 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63776 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1762463AbZDJATh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 20:19:37 -0400
Message-ID: <49DE90BF.1010800@cn.fujitsu.com>
Date: Fri, 10 Apr 2009 08:20:15 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: serue@us.ibm.com, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org
Subject: Re: [PATCH] devcgroup: skip superfluous checks when found the DEV_ALL
 elem
References: <49DAE8E4.2030106@cn.fujitsu.com> <20090409170610.9ee6e8e4.akpm@linux-foundation.org>
In-Reply-To: <20090409170610.9ee6e8e4.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 07 Apr 2009 13:47:16 +0800
> Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
>> While walking through the whitelist, if the DEV_ALL item is found,
>> no more check is needed.
>>
> 
> It's unobvious whether this is a behavioural change, a bugfix or just a
> speedup?
> 

It's a speedup. I thought it's obvious by saying "skip superfluous checks"..


