Return-Path: <linux-kernel-owner+w=401wt.eu-S1753876AbZKTJP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbZKTJP0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 04:15:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753384AbZKTJPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 04:15:25 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:57428 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298AbZKTJPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 04:15:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=m7SoyepG0QVqT6/BMbUtrfDXYPXTm+xbgIn11OwXMhIcMmPxpk4+i6pD8sDTrKY12U
         KfF4Q8mb1ILI4JjtAZGdReF8WsAvjQatPCwLkeZF+gznCp9iLuP1LDekahsl2GPQDvwG
         7hrcOXpGkZUCJXAMHsYB1Oq71Xz4N6P5n1KUk=
MIME-Version: 1.0
In-Reply-To: <20091120090134.GD19778@elte.hu>
References: <4B064AF5.9060208@cn.fujitsu.com> <20091120081440.GA19778@elte.hu>
	 <84144f020911200019p4978c8e8tc593334d974ee5ff@mail.gmail.com>
	 <20091120083053.GB19778@elte.hu> <4B0657A4.2040606@cs.helsinki.fi>
	 <20091120090134.GD19778@elte.hu>
Date: Fri, 20 Nov 2009 11:15:23 +0200
X-Google-Sender-Auth: 30d6af3348aa853d
Message-ID: <84144f020911200115g14cfa3b5k959f8751001b8b35@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/2] perf: Add 'perf kmem' tool
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Fri, Nov 20, 2009 at 11:01 AM, Ingo Molnar <mingo@elte.hu> wrote:
> But ... even without that, perf is really fast and is supposed to build
> fine even in minimal (embedded) environments, so you can run it on the
> embedded board too. That's useful to get live inspection features like
> 'perf top', 'perf stat' and 'perf probe' anyway.

Maybe I'm just too damn lazy but if I don't go through the trouble of
building my kernel on the box, I sure don't want to do that for perf
either. Anyway, I'm sure we can fix "perf kmem" to support what
kmemtrace-user does so it's not an issue.

                        Pekka
