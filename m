Return-Path: <linux-kernel-owner+w=401wt.eu-S1756753AbYLDNGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753AbYLDNGv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 08:06:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753929AbYLDNG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 08:06:26 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:57502 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbYLDNGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 08:06:24 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, containers@lists.osdl.org,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 3/3] ftrace: add ability to only trace swapper tasks
References: <20081204052638.425740534@goodmis.org>
	<20081204052735.362609481@goodmis.org>
	<20081204001803.598063f5.akpm@linux-foundation.org>
	<20081204091023.GJ32594@elte.hu>
Date: Thu, 04 Dec 2008 04:59:04 -0800
In-Reply-To: <20081204091023.GJ32594@elte.hu> (Ingo Molnar's message of "Thu,
	4 Dec 2008 10:10:23 +0100")
Message-ID: <m1vdu0t7tz.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: No (on mx04.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Andrew Morton <akpm@linux-foundation.org> wrote:
>
>> > Signed-off-by: Steven Rostedt <srostedt@redhat.com>
>> 
>> What does this patch actually do?  Is swapper currently excluded from 
>> tracing for undisclosed reasons and this patch permits it to be traced? 
>> If so, why was swapper thus excluded?  Or am I totally off track?
>
>> > +static struct pid * const ftrace_swapper_pid = (struct pid *)1;
>> 
>> eh?
>
> all side-effects of getting rid of the integer based PID namespace and 
> replacing them with struct pid pointers.

Thanks for asking Andrew it looks like an unnecessary side effect.

Eric
