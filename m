Return-Path: <linux-kernel-owner+w=401wt.eu-S1756439AbZKBV0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439AbZKBV0c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 16:26:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755517AbZKBV0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 16:26:31 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:60262 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755410AbZKBV0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 16:26:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hWyhkXJQFQqo54haRr5iN3y5s4F8mhtZt6ZLjb0UWqBmNJDlv2ALqmdfkev9fwDKm/
         vwN2ue5oYKq8N8cd24T6oSfAbO4QRkakxDE58JKtLbu31Zh1K8Nsntvp+dOs5PdARl+g
         PXtiwIAGVBpHDTuxU+aO2upxpnyVnReK54rYo=
Date: Mon, 2 Nov 2009 22:26:33 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip perf/probes 00/10] x86 insn decoder bugfixes and
	perf-probe syntax changes
Message-ID: <20091102212632.GH4880@nowhere>
References: <20091027204156.30545.96425.stgit@harusame> <20091029085348.GD26970@elte.hu> <4AE9C919.4070003@redhat.com> <4AEF4C29.2060501@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AEF4C29.2060501@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 04:16:25PM -0500, Masami Hiramatsu wrote:
> Masami Hiramatsu wrote:
>> Ingo Molnar wrote:
>>> What we want here is two fold:
>>>
>>>    - enable kprobes event support when perf events is enabled and kprobes
>>>      is enabled. We dont want another config option for it.
>>
>> Sure, at least that combination should enable kprobe-tracer forcibly.
>
> Hmm, someone may not want to enables kprobe-tracer. Perhaps,
> "default y if (EVENT_PROFILE)" is enough, isn't it?
>


I guess it should be sufficient yeah. We want to strongly recommend
the kprobe events if we have enabled perf, but we don't want to force
it.

Also in this case we need a verbose runtime report of the lack of this
tracer in debugfs from perf probe if needed.

