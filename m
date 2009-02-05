Return-Path: <linux-kernel-owner+w=401wt.eu-S1756357AbZBEOzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357AbZBEOzS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 09:55:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418AbZBEOzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 09:55:05 -0500
Received: from main.gmane.org ([80.91.229.2]:57701 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699AbZBEOzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 09:55:04 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Harald Hoyer <harald@redhat.com>
Subject: Re: [PATCH] tracer for sys_open() - sreadahead
Date: Thu, 05 Feb 2009 15:44:42 +0100
Message-ID: <gmeu0q$n13$1@ger.gmane.org>
References: <497F69A4.2070007@intel.com> <20090130202219.GA1253@ucw.cz> <20090203133251.GD29046@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: p578ffc87.dip.t-dialin.net
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
In-Reply-To: <20090203133251.GD29046@elte.hu>
Cc: power@bughost.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Pavel Machek <pavel@suse.cz> wrote:
> 
>> On Tue 2009-01-27 12:08:04, Kok, Auke wrote:
>>> This tracer monitors regular file open() syscalls. This is a fast
>>> and low-overhead alternative to strace, and does not allow or
>>> require to be attached to every process.
>>>
>>> The tracer only logs succesfull calls, as those are the only ones we
>>> are currently interested in, and we can determine the absolute path
>>> of these files as we log.
>> Maybe fanotify() should be used instead?
>>
>> Or maybe just plain strace? One slow boot should not really hurt...
> 
> ptrace is out of question for good tracing because it's not a transparent 
> probe. (ptrace monopolizes the traced task - if we use that then we break 
> regular strace usage.)
> 
> 	Ingo

Can strace can be used on init?

$ man strace
...
        On Linux, exciting as it would be, tracing the init process is forbidden.
...

Any hope getting _any_ mechanism in the kernel??

