Return-Path: <linux-kernel-owner+w=401wt.eu-S1753967AbZDPHyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbZDPHyB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 03:54:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbZDPHxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 03:53:51 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53330 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750713AbZDPHxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 03:53:50 -0400
Message-ID: <49E6E439.1090607@cn.fujitsu.com>
Date: Thu, 16 Apr 2009 15:54:33 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC][PATCH 1/2] tracing/events: provide string with undefined
 size support
References: <1239838050-8567-1-git-send-email-fweisbec@gmail.com> <49E68635.8050404@cn.fujitsu.com> <20090416074250.GB6021@nowhere>
In-Reply-To: <20090416074250.GB6021@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> +	entry	= ring_buffer_event_data(event);			       \
>> small nits, below is better since we have only one assignment:
>>
>> 	entry = ring_buffer_event_data(event);
> 
> 
> 
> Hm, I don't understand what you are suggesting.
> 

I meant just add a ' ' before '=' instead of a tab:

entry = ring_buffer_event_data(event);
entry	= ring_buffer_event_data(event);

since we don't need to align with other assignment statement.

but this is just a trivial issue. :)

--
Zefan
