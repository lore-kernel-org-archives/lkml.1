Return-Path: <linux-kernel-owner+w=401wt.eu-S1754260AbZENNlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260AbZENNlh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 09:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752903AbZENNl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 09:41:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38688 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574AbZENNlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 09:41:25 -0400
Date: Thu, 14 May 2009 15:41:25 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Minchan Kim <minchan.kim@gmail.com>
Cc: leemgs1@gmail.com, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       williams <williams@redhat.com>, tglx <tglx@linutronix.de>,
       Jiri Kosina <trivial@kernel.org>
Subject: Re: [PATCH]append prompt in /debug/tracing/README file.
In-Reply-To: <28c262360905140128q3458e39fu62def873f2d95ae0@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.0905141540470.22712@wotan.suse.de>
References: <1242289418.31161.45.camel@centos51> <28c262360905140128q3458e39fu62def873f2d95ae0@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="168427776-1233069248-1242308485=:22712"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--168427776-1233069248-1242308485=:22712
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 14 May 2009, Minchan Kim wrote:

> >    Please, Append prompt in /debug/tracing/README file.
> >
> >    This is trivial issue. Fix typo Mini Howto file(README) for ftrace.
> >
> >    Signed-off-by: GeunSik Lim <geunsik.lim@samsung.com>
> >
> > diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> > index 1ce5dc6..a4726f5 100644
> > --- a/kernel/trace/trace.c
> > +++ b/kernel/trace/trace.c
> > @@ -2380,7 +2380,7 @@ static const char readme_msg[] =
> >        "# echo print-parent > /debug/tracing/trace_options\n"
> >        "# echo 1 > /debug/tracing/tracing_enabled\n"
> >        "# cat /debug/tracing/trace > /tmp/trace.txt\n"
> > -       "echo 0 > /debug/tracing/tracing_enabled\n"
> > +       "# echo 0 > /debug/tracing/tracing_enabled\n"
> >  ;
> >
> >  static ssize_t

I have applied this to trivial tree. If anyone else has already applied it 
to his tree, please let me know so that I can drop it.

Thanks,

-- 
Jiri Kosina
SUSE Labs
--168427776-1233069248-1242308485=:22712--
