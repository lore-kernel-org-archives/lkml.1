Return-Path: <linux-kernel-owner+w=401wt.eu-S1754387AbZIAM35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387AbZIAM35 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 08:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754332AbZIAM34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 08:29:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50662 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754321AbZIAM34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 08:29:56 -0400
Message-ID: <4A9D13C1.4030902@cn.fujitsu.com>
Date: Tue, 01 Sep 2009 20:29:53 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] tracing: make splice_read work when data is	sufficient
References: <4A95F743.2090101@cn.fujitsu.com> <20090829094503.GA6418@nowhere>
In-Reply-To: <20090829094503.GA6418@nowhere>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
>>  	 */
>> +	cpu_buffer->reader_page->read = 0;
> 
> 
> 
> Wasn't this reset done before?
> 
> 

This is not reset. It is still used just before this line.

> 
> 
> Reviewed-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> 

Ingo, Could you apply this patch and fix the bug?

