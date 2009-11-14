Return-Path: <linux-kernel-owner+w=401wt.eu-S932530AbZKNA1E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530AbZKNA1E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 19:27:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757648AbZKNA1B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 19:27:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757602AbZKNA1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 19:27:00 -0500
Message-ID: <4AFDF912.10203@redhat.com>
Date: Fri, 13 Nov 2009 19:25:54 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip 2/3] Add coredump tracepoint
References: <20091113225226.15079.90813.stgit@harusame>	<20091113225233.15079.41600.stgit@harusame>	<20091113233912.192A3100E@magilla.sf.frob.com>	<20091114000234.GA24738@elte.hu> <20091114000627.48ED615E8@magilla.sf.frob.com>
In-Reply-To: <20091114000627.48ED615E8@magilla.sf.frob.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath wrote:
>> Oh, so SystemTap is the motivator of these tracepoints?
>
> Nope.  My suggestion about arguments to pass was just generic based on the
> innate context of this tracepoint.
>
>> Do you know about exact usecases where these tracepoints would be
>> utilized? Would be interesting (and relevant) to list them.
>
> Masami's colleagues do have something in particular in mind,
> but I'm not sure whether they intend to use systemtap as part
> of the implementation of that or not.

Yeah, we'd like to use this tracepoint to analyze coredump
miss-configuration. Sometimes, users miss-configure dump-filter
and rlimit, that will cause system-slowdown when several processes,
which share a large amount of memory among them (e.g. database),
start core-dump with shared memory. And then, it can cause a
system-switching on HA cluster system.

With this tracepoint, we can analyze why the coredumps were slow.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

