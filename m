Return-Path: <linux-kernel-owner+w=401wt.eu-S1755820Ab0ARSCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820Ab0ARSCz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 13:02:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755475Ab0ARSCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 13:02:54 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:49400 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719Ab0ARSCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 13:02:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ffpEERk15AMX12rNKXemQAcHKVmhhFqHTtnF8Xv2lMuTWLfey6zHWWXqFezuczQWxZ
         ag1zuCEpL/28y8nAFWruQoEQvc6uXIVrDBgzYUZ7EwflHTwXIHQWUsc4/fh3tgtJZQ8f
         cS99GAZ63c20gBJrTEsfymfTHvqSTTT2Fd5G8=
Date: Mon, 18 Jan 2010 19:02:50 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] perf_event: cleanup for event profile buffer
	operation
Message-ID: <20100118180248.GN10364@nowhere>
References: <4B54654A.4090601@cn.fujitsu.com> <4B5465D8.9070203@cn.fujitsu.com> <4B548A9A.1020806@redhat.com> <20100118172021.GL10364@nowhere> <4B549F00.6060704@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B549F00.6060704@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 12:48:48PM -0500, Masami Hiramatsu wrote:
> > So, as more generic names, I would suggest:
> > 
> > ftrace_perf_buf_fill() and ftrace_perf_buf_submit().
> 
> 
> Actual filling buffer is done in the profile handlers,
> so I think ftrace_perf_buf_prepare() may be better :-)
> ftrace_perf_buf_submit is good to me:-)


Oh you're right :)

