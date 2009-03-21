Return-Path: <linux-kernel-owner+w=401wt.eu-S1755089AbZCUU6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089AbZCUU6b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 16:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753388AbZCUU6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 16:58:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57529 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786AbZCUU6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 16:58:23 -0400
Message-ID: <49C554F2.1030408@redhat.com>
Date: Sat, 21 Mar 2009 16:58:26 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Jim Keniston <jkenisto@us.ibm.com>
Subject: Re: [RFC][PATCH -tip 4/5 V2] kprobes: support respawn probes for
 	module probing
References: <49C4440B.8030300@redhat.com> <20090321020044.GE6044@nowhere>
In-Reply-To: <20090321020044.GE6044@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Fri, Mar 20, 2009 at 09:34:03PM -0400, Masami Hiramatsu wrote:
[...]
>> +static int add_module_probe(const char *module, void *p, enum probe_type type,
>> +			    probe_activate_handler_t handler, void *data)
>> +{
>> +	struct module_probe_client *pc;
>> +	int ret = 0;
>> +
>> +	if (!handler)
>> +		return -EINVAL;
>> +
>> +	pc = kzalloc(sizeof(struct module_probe_client), GFP_KERNEL);
> 
> 
> You forgot something here. Right? ;-)

Oops, sure...

Thank you!


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


