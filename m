Return-Path: <linux-kernel-owner+w=401wt.eu-S1755732Ab0ASJAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732Ab0ASJAM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 04:00:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755573Ab0ASJAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 04:00:10 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:44301 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023Ab0ASJAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 04:00:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DgqHr6gtgpB9FOSENuHbK00wbOt1X/wfw8qfo2Hd47VnhlVAY/Fv466Hr4E7PFmSct
         Phfa4WNx4w18Jr6PO+Ak0Si5gfkWxlyiTQxpbQGQpL9nqvmHOsAOJI9JOeEVJ5ezGEsr
         6+FeOV3Wy+s+4gWxWhiA8WjnVwOUugxqJpj7A=
Date: Tue, 19 Jan 2010 10:00:03 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] perf_event: cleanup for event profile buffer
	operation
Message-ID: <20100119085958.GB5145@nowhere>
References: <4B54654A.4090601@cn.fujitsu.com> <4B5465D8.9070203@cn.fujitsu.com> <4B548A9A.1020806@redhat.com> <20100118172021.GL10364@nowhere> <4B549F00.6060704@redhat.com> <4B550A32.6010508@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B550A32.6010508@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 19, 2010 at 09:26:10AM +0800, Xiao Guangrong wrote:
> > Actual filling buffer is done in the profile handlers,
> > so I think ftrace_perf_buf_prepare() may be better :-)
> > ftrace_perf_buf_submit is good to me:-)
> > 
> 
> OK, i'll rename those functions and add __kprobe for ftrace_perf_buf_prepare(),
> i guess i can add you Acked-by :-)


You can add mine yeah (couldn't tell for Masami).

