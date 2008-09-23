Return-Path: <linux-kernel-owner+w=401wt.eu-S1753003AbYIWPcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003AbYIWPcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 11:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbYIWPcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 11:32:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456AbYIWPcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 11:32:05 -0400
Message-ID: <48D90B84.4030905@redhat.com>
Date: Tue, 23 Sep 2008 11:30:12 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
CC: Martin Bligh <mbligh@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, darren@dvhart.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: Unified tracing buffer
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com> <48D7F5E8.3000705@redhat.com> <33307c790809221313s3532d851g7239c212bc72fe71@mail.gmail.com> <48D81B5F.2030702@redhat.com> <33307c790809221616h5e7410f5gc37c262d83722111@mail.gmail.com> <48D832B6.3010409@redhat.com> <33307c790809221712x4fbd9781u958c98d4585e92a9@mail.gmail.com> <48D901FE.5060604@redhat.com> <20080923150410.GA28341@Krystal>
In-Reply-To: <20080923150410.GA28341@Krystal>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Masami Hiramatsu (mhiramat@redhat.com) wrote:
> [...]
>> $ cat /proc/cpuinfo
>> processor	: 0
>> vendor_id	: GenuineIntel
>> cpu family	: 6
>> model		: 15
>> model name	: Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz
>> stepping	: 6
>> cpu MHz		: 1000.000
> [...]
> 
> ... @ 2.00GHz and cpu MHz : 1000.000 ; isn't that a bit odd ? (same for
> both cpus)

2.00GHz is the maximum(model) frequency. And 'cpu MHz' means
current frequency. (yep, now I'm using cpufreq)
Anyway, when I measured TSC drift, I killed cpuspeed service and
fixed freq to 2000. ;-)

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

