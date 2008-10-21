Return-Path: <linux-kernel-owner+w=401wt.eu-S1753493AbYJUOeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbYJUOeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 10:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751552AbYJUOeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 10:34:08 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:60478 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbYJUOeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 10:34:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=M4uyH+7BaYknhCqzP8pgnRoTIF8VRczsnI+8q1TpvCSHENDSLXcomGU53pywhUHz5k
         wGThmHl7hJhD0Q9ckj+UjQLvZAaVwzvFU7hYEOU9mHQu/mQhp8XbdvMHJZdRaiVEvzxb
         GYQYK4YDok++i/Cc+7w+x/3uDq8Pb8MjQKOJ8=
Message-ID: <c62985530810210734l2d6a7647tf0d38e74f1a60981@mail.gmail.com>
Date: Tue, 21 Oct 2008 16:34:05 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: [PATCH] trace: create tracers menu
Cc: linux-kernel <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Steven Rostedt" <rostedt@goodmis.org>
In-Reply-To: <1224599478.22771.45.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1224599478.22771.45.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/21 Peter Zijlstra <peterz@infradead.org>:
> Subject: trace: create tracers menu
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Tue Oct 21 16:26:36 CEST 2008
>
> We seem to have plenty tracers, lets create a menu and not clutter
> the already cluttered debug menu more.
>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/trace/Kconfig |    4 ++++
>  1 file changed, 4 insertions(+)
>
> Index: linux-2.6/kernel/trace/Kconfig
> ===================================================================
> --- linux-2.6.orig/kernel/trace/Kconfig
> +++ linux-2.6/kernel/trace/Kconfig
> @@ -29,6 +29,8 @@ config TRACING
>        select STACKTRACE
>        select TRACEPOINTS
>
> +menu "Tracers"
> +
>  config FUNCTION_TRACER
>        bool "Kernel Function Tracer"
>        depends on HAVE_FUNCTION_TRACER
> @@ -191,3 +193,5 @@ config FTRACE_STARTUP_TEST
>          a series of tests are made to verify that the tracer is
>          functioning properly. It will do tests on all the configured
>          tracers of ftrace.
> +
> +endmenu


Good Idea :)
