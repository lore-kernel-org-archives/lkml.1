Return-Path: <linux-kernel-owner+w=401wt.eu-S1753017AbYLZGXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017AbYLZGXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 01:23:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750857AbYLZGXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 01:23:04 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:60392 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbYLZGXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 01:23:01 -0500
X-AuditID: 0ac90648-a97a9ba000001b6c-b3-49547844b839
Message-ID: <49547836.7040907@hitachi.com>
Date: Fri, 26 Dec 2008 15:22:46 +0900
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, yumiko.sugita.yf@hitachi.com,
       satoshi.oshima.fk@hitachi.com
Subject: Re: [PATCH] coredump_filter: enable to change the default filter
References: <4940B426.6040509@hitachi.com> 
    <20081211154349.5000.KOSAKI.MOTOHIRO@jp.fujitsu.com> 
    <20081211151003.00572e04.akpm@linux-foundation.org> 
    <20081211232205.ED188FC3AB@magilla.sf.frob.com> 
    <494B71D6.3080602@hitachi.com> 
    <20081219195311.81C4AFC351@magilla.sf.frob.com>
In-Reply-To: <20081219195311.81C4AFC351@magilla.sf.frob.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm sorry for late reply.

Roland McGrath wrote:

>>However, we would need a special care for PID namespace if we use
>>init's coredump_filter as default.  For a process with new PID
>>namespace and new /proc, writing to /proc/1/coredump_filter doesn't
>>mean changing default, although it's not a usual operation.
> 
> I'd figured that private PID namespaces with their own init would want
> their own private settings for this default too.

Probably it's true, but I'm not sure if having coredump_filter have
two means is acceptable.  init in a private PID namespace can die
and dump a core file.  So its coredump_filter has two means; default
setting for the namespace and setting for itself.  
 
Thanks,
-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center


