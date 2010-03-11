Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290Ab0CKHbi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 02:31:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19686 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753106Ab0CKHbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 02:31:37 -0500
Message-ID: <4B989C4A.1020003@redhat.com>
Date: Thu, 11 Mar 2010 09:31:22 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kvm: cleanup kvm trace
References: <4B977BDB.2090204@cn.fujitsu.com>
In-Reply-To: <4B977BDB.2090204@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2010 01:00 PM, Xiao Guangrong wrote:
> This patch does:
>
>   - no need call tracepoint_synchronize_unregister() when kvm module
>     is unloaded since ftrace can handle it
>
>   - cleanup ftrace's macro
>    

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

