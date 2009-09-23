Return-Path: <linux-kernel-owner+w=401wt.eu-S1752444AbZIWLr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444AbZIWLr7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 07:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbZIWLr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 07:47:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27370 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519AbZIWLr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 07:47:57 -0400
Message-ID: <4ABA0AA6.3010408@redhat.com>
Date: Wed, 23 Sep 2009 14:46:46 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Daniel Walker <dwalker@fifo99.com>
CC: Jonathan Corbet <corbet@lwn.net>, Raistlin <raistlin@linux.it>,
       Peter Zijlstra <peterz@infradead.org>, claudio@evidence.eu.com,
       michael@evidence.eu.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, johan.eker@ericsson.com, p.faure@akatech.ch,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
Subject: Re: [RFC][PATCH] SCHED_EDF scheduling class
References: <1253615424.20345.76.camel@Palantir>	 <1253625878.6575.34.camel@desktop> <20090922173916.257dff1d@tpl.lwn.net>	 <1253663739.4317.12.camel@desktop>  <20090922180611.7a47adcc@tpl.lwn.net> <1253666423.25689.30.camel@desktop>
In-Reply-To: <1253666423.25689.30.camel@desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2009 03:40 AM, Daniel Walker wrote:
> I am trying to make the kernel (or community) better, but my motivation
> is purely my own (as it often is with people on this list) ..
>
> I don't see the effects your indicating, discouraging contributions .. I
> think if anything I'm helping people to get to a place where they can
> contribute in a comfortable way without worrying about things like
> checkpatch .. I think the problem most submitters have on this list is
> that no one tells them they are doing something wrong so they don't
> correct it. I clearly recall submitting my first several patches
> copy-and-pasted which got either ignored , or caused a maintainer lots
> of pain .. Had I been told earlier that it was a problem I would have
> corrected it immediately (and been happy to have been notified about
> it)..
>
>    

Look at the context.  Here we have a new scheduling class introduced out 
of the blue.  The discussion should be around whether it makes sense; if 
it does, whether the design is good or not; if it is, whether the code 
is maintainable or not, if that passes, whether there are bugs in the 
code or not.  Until we've decided that Linux needs this scheduling class 
and that this patchset is well designed and written, spelling errors are 
just a nuisance and distract people from the important issues.

> discouraging contributions is more something that happens when you get
> the responses I got earlier in this thread..
>    

That's probably intentional.  Whitespace fixes have their place but not 
at this stage in a patch's lifecycle.

-- 
error compiling committee.c: too many arguments to function

