Return-Path: <linux-kernel-owner+w=401wt.eu-S1758247AbYLDOgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758247AbYLDOgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 09:36:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753882AbYLDOg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 09:36:27 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:49894 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414AbYLDOg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 09:36:26 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, containers@lists.osdl.org,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/3] ftrace: use struct pid
References: <20081204052638.425740534@goodmis.org>
	<20081204052735.175697908@goodmis.org>
	<m11vwoumjn.fsf@frodo.ebiederm.org>
	<alpine.DEB.1.10.0812040921410.5240@gandalf.stny.rr.com>
Date: Thu, 04 Dec 2008 06:32:55 -0800
In-Reply-To: <alpine.DEB.1.10.0812040921410.5240@gandalf.stny.rr.com> (Steven
	Rostedt's message of "Thu, 4 Dec 2008 09:23:07 -0500 (EST)")
Message-ID: <m1abbct3hk.fsf@frodo.ebiederm.org>
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

Steven Rostedt <rostedt@goodmis.org> writes:

> On Thu, 4 Dec 2008, Eric W. Biederman wrote:
>
>> Steven Rostedt <rostedt@goodmis.org> writes:
>> 
>> > From: Steven Rostedt <srostedt@redhat.com>
>> >
>> > Impact: clean up
>> >
>> > Eric Biederman suggested using the struct pid for filtering on
>> > pids in the kernel. This patch is based off of a demonstration
>> > of an implementation that Eric sent me in an email.
>> 
>> Please find_get_vpid and pid_vnr.  
>
> I could not find a "find_get_vpid".

Doh.  Grumble Pavel Grumble.

find_get_pid is the right one.

Sorry.  We have a stupid inconsistency in the naming here,
If we were consistent it would be find_get_vpid.

pid_vnr in that case then pid_vnr is definitely what you want
to use when talking to user space.

Eric
