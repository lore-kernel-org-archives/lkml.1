Return-Path: <linux-kernel-owner+w=401wt.eu-S1756853AbYCMXnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853AbYCMXnj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 19:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbYCMXna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 19:43:30 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:52393 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbYCMXn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 19:43:29 -0400
Message-ID: <47D9BAA6.4010409@cn.fujitsu.com>
Date: Fri, 14 Mar 2008 08:37:10 +0900
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Menage <menage@google.com>, Pavel Emelianov <xemul@openvz.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH 3/3] memcgoup: allow memory.failcnt to be reset
References: <47D65A3E.100@cn.fujitsu.com> <20080311191649.32a2cbae.kamezawa.hiroyu@jp.fujitsu.com> <47D65B99.3070208@linux.vnet.ibm.com>
In-Reply-To: <47D65B99.3070208@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> KAMEZAWA Hiroyuki wrote:
>> On Tue, 11 Mar 2008 19:09:02 +0900
>> Li Zefan <lizf@cn.fujitsu.com> wrote:
>>
>>> Allow memory.failcnt to be reset to 0:
>>>
>>>         echo 0 > memory.failcnt
>>>
>>> And '0' is the only valid value.
>>>
>> Can't this be generic resource counter function ?
>>
> 
> I was about to suggest a generic cgroup option, since we do reset values even
> for the cpu accounting subsystem.
> 

It won't help. You still have to write the write function, and you have to call
some res_counter routines to reset the value, and maybe also do some other
work.

