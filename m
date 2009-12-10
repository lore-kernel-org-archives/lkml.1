Return-Path: <linux-kernel-owner+w=401wt.eu-S1756104AbZLJVWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbZLJVWQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 16:22:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753448AbZLJVWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 16:22:14 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:26210
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750963AbZLJVWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 16:22:13 -0500
X-SpamScore: -21
X-BigFish: VPS-21(zz1432R98dN936eMzz1202hz4fhzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <4B216670.60807@am.sony.com>
Date: Thu, 10 Dec 2009 13:21:52 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "Bird, Tim" <Timothy.Bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 4/4] ftrace - function_duration Documentation
References: <4B2027C7.9010509@am.sony.com> <1260416840.2146.134.camel@gandalf.stny.rr.com>
In-Reply-To: <1260416840.2146.134.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Dec 2009 21:21:53.0756 (UTC) FILETIME=[CB8349C0:01CA79DE]
X-SEL-encryption-scan: scanned
X-Reverse-DNS: mail8.fw-sd.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Wed, 2009-12-09 at 14:42 -0800, Tim Bird wrote:
>> Documentation for function_duration tracer.
> 
>> +The purpose of the function duration tracer is to help find the
>> +longest-running, most time-consuming functions in the Linux kernel.
>> +This is especially important for early initialization, to reduce
>> +kernel boot time.
>> +
>> +Function duration tracing uses the ftrace ability to hook both the
>> +entry and exit of a function, to record duration information for
>> +kernel functions.  This is similar to the function_graph tracer, but
>> +the function_duration tracer is specially written to support filtering
>> +by duration and decreased tracer overhead while filtering.
>> +
>> +This extends the amount of time that a trace can cover, and reduces
>> +interference with the timing of the traced activity.
> 
> BTW, have you taken a look at the function profiler? It also keeps track
> of all durations without using the ring buffer. It just adds them up and
> gives an average time.

I haven't, but I should.  However, my tool has some other options
(like subtracting time spent in interrupts) that I don't
think the profile approach currently supports.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

