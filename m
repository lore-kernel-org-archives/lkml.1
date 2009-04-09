Return-Path: <linux-kernel-owner+w=401wt.eu-S1760920AbZDIFRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760920AbZDIFRA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 01:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754621AbZDIFQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 01:16:50 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:32837 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbZDIFQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 01:16:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=PaHV5aprfgEHGJZNIBgM2sNC2CXrsFhEHjCgR/wEJDNGpsI4hvnvBuFAE2Hi4OMuVJ
         lr3yB8C2rB8j1PA2WzV6Cp603uZSs5iQgcpKS7XQdzs76JnvDDF9/MM4A9k1wvHmLzsp
         my5WgzpGldod5oMz19W5vjnIV5HkzbDTzQb8I=
MIME-Version: 1.0
In-Reply-To: <20090409041319.GE20692@elte.hu>
References: <49DD6E2B.6090200@cn.fujitsu.com> <49DD70E0.9080302@cn.fujitsu.com>
	 <49DD728D.8030608@cn.fujitsu.com> <20090409041319.GE20692@elte.hu>
Date: Thu, 9 Apr 2009 08:16:46 +0300
X-Google-Sender-Auth: 4722fabf7ea00954
Message-ID: <84144f020904082216hfb5f5ene87781f9aaf7e76c@mail.gmail.com>
Subject: Re: [PATCH][RESEND] tracing: consolidate documents
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Li Zefan <lizf@cn.fujitsu.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Pekka Paalanen <pq@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 9, 2009 at 7:13 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Li Zefan <lizf@cn.fujitsu.com> wrote:
>
>> Li Zefan wrote:
>> > Move tracepoints.txt, ftrace.txt and mmiotrace.txt to the new
>> > directory trace/
>> >
>>
>> Should we also move kmemtrace.txt to trace/, or leave it in vm/?
>
> Eduard, Pekka, any preferences?
>
> Are symbolic links in Documentation/ frowned upon? I think it would
> be best to have the file in both places:
>
> We do want to direct people interested in Documentation/vm/ to
> kmemtrace ... and we do want to let people who are interested in
> Documentation/trace/ that there's kmemtrace.
>
> Tracing and instrumentation is generally a multi-subsystem thing.

I'm not sure a symbolic link is necessary. Just put it under trace/.
