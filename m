Return-Path: <linux-kernel-owner+w=401wt.eu-S1751686AbXDFTV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686AbXDFTV6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 15:21:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbXDFTV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 15:21:57 -0400
Received: from terminus.zytor.com ([192.83.249.54]:41962 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbXDFTV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 15:21:56 -0400
Message-ID: <46169DC5.3020502@zytor.com>
Date: Fri, 06 Apr 2007 12:21:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Robin Holt <holt@sgi.com>,
       Chris Snook <csnook@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: init's children list is long and slows reaping children.
References: <20070406084250.GA179@tv-sign.ru>	<m18xd5amwq.fsf@ebiederm.dsl.xmission.com>	<20070406094413.GA673@tv-sign.ru>	<m1lkh58q16.fsf@ebiederm.dsl.xmission.com>	<20070406154750.GA541@tv-sign.ru>	<Pine.LNX.4.64.0704061013060.6730@woody.linux-foundation.org>	<m1ejmx76fk.fsf@ebiederm.dsl.xmission.com>	<46169A34.3030808@zytor.com> <m1slbd5n7u.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1slbd5n7u.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
>>>
>> Are you saying waitpid() (wait4) *with a pid specified* can return another pid?
>> That definitely sounds like a bug.
> 
> No.
> 
> For the full context look back a couple of messages.
> 
> I'm guessing the issue is nash just calls wait and doesn't check the
> returned pid value, assuming it is the only child it forked returning.
> Which is valid except when you are running as pid == 1.
> 

OK, userspace error :)

	-hpa
