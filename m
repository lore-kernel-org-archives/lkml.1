Return-Path: <linux-kernel-owner+w=401wt.eu-S1754252AbZALSJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252AbZALSJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 13:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbZALSJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 13:09:05 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:47444 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbZALSJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 13:09:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=rGOqK31iAYEdIVLFqFI7cP/r1ZgMihoq3G3dVoMCiyR6dXPyRnMryercU0zWQnkyqg
         eqhEg0ZEd5Ab/FW23hfa9FxhmFiGANtp34OVws01aR5PQOCOdW0jp1gRKfAujdxJAaco
         03WoXui7LVVvOU/bvLD8VnvZmhyai2ogfxQy4=
Message-ID: <c62985530901121009h372c805dj14c748c8f266235d@mail.gmail.com>
Date: Mon, 12 Jan 2009 19:09:00 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: checkpatch warning of struct indentation
Cc: "Andy Whitcroft" <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0901121253350.22796@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.DEB.1.10.0901121253350.22796@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/12 Steven Rostedt <rostedt@goodmis.org>:
>
> Hi,
>
> I'm now seeing the following warnings from checkpatch:
>
> #325: FILE: kernel/trace/trace_stat.c:21:
> +       void                    *stat;
>
> ERROR: "foo     *bar" should be "foo *bar"
> #334: FILE: kernel/trace/trace_stat.c:27:
> +       struct tracer_stat      *ts;
>
> ERROR: "foo             *bar" should be "foo    *bar"
> #337: FILE: kernel/trace/trace_stat.c:30:
> +       struct dentry           *file;


Oh my patch :-)
Yeah I had the same errors when I checked it. I ignored them because
I because I remembered checkpatch.pl didn't warn about such things before.
And it seems to warn about such statements since very recently...


> This is for:
>
> struct tracer_stat_session {
>        struct list_head        session_list;
>        struct tracer_stat      *ts;
>        struct list_head        stat_list;
>        struct mutex            stat_mutex;
>        struct dentry           *file;
> };
>
> Which looks a hell of a lot better than:
>
> struct tracer_stat_session {
>        struct list_head session_list;
>        struct tracer_stat *ts;
>        struct list_head stat_list;
>        struct mutex stat_mutex;
>        struct dentry *file;
> };
>
> We probably do not want to warn on such things.
>
> -- Steve
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
