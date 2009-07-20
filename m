Return-Path: <linux-kernel-owner+w=401wt.eu-S1752399AbZGTBdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399AbZGTBdZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 21:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbZGTBdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 21:33:25 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56068 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752284AbZGTBdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 21:33:24 -0400
Message-ID: <4A63C8FF.4040001@cn.fujitsu.com>
Date: Mon, 20 Jul 2009 09:31:43 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Tom Zanussi <tzanussi@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/filters: Improve subsystem filter
References: <4A5EECDC.4080500@cn.fujitsu.com> <20090717203422.GA7136@nowhere> <4A63C166.8010201@cn.fujitsu.com> <20090720012430.GA5172@nowhere>
In-Reply-To: <20090720012430.GA5172@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> bool dry_run sounds perhaps more intuitive for what is happening there.
>> I guess you "try_run". ;)
>>
>>> Because "apply" is surprising in a "add_thing" function, it's like
>>> a field to confirm that we know what what we are doing :)
>>>
>>> (May be I start to become a PITA with my naming worries, especially
>>> since I'm usually not good at it in my patches :)
>>>
>> I'll take "try_run". Naming is often hard for me.
> 
> 
> No I really meant "dry run"
> "Try run" is already a function that would implicitly fit into
> every function :)
> 
> Ie, dry run means:
> 
> "Behave as if you were truly doing it, just to see if it works.
> But don't really do it"
> 

Got it. Thanks. :)

