Return-Path: <linux-kernel-owner+w=401wt.eu-S1759997AbZB0BOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759997AbZB0BOP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 20:14:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbZB0BN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 20:13:58 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:43136 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbZB0BN5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 20:13:57 -0500
MIME-Version: 1.0
In-Reply-To: <20090222000521.17557.93357.stgit@vmbox.hanneseder.net>
References: <20090221235706.17557.97714.stgit@vmbox.hanneseder.net>
	 <20090222000521.17557.93357.stgit@vmbox.hanneseder.net>
Date: Fri, 27 Feb 2009 02:13:53 +0100
Message-ID: <154e089b0902261713w52323573j8283b697562a58e9@mail.gmail.com>
Subject: Re: [PATCH 13/16] kprobes: fix sparse warnings: Using plain integer 
	as NULL pointer
From: Hannes Eder <hannes@hanneseder.net>
To: trivial@kernel.org, Ingo Molnar <mingo@elte.hu>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added To]

On Sun, Feb 22, 2009 at 1:05 AM, Hannes Eder <hannes@hanneseder.net> wrote:
> Fix this sparse warnings:
>  kernel/test_kprobes.c:118:19: warning: Using plain integer as NULL pointer
>  kernel/test_kprobes.c:213:22: warning: Using plain integer as NULL pointer
>  kernel/test_kprobes.c:326:22: warning: Using plain integer as NULL pointer
>
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>
> ---
>  kernel/test_kprobes.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/test_kprobes.c b/kernel/test_kprobes.c
> index 4f10451..9a43351 100644
> --- a/kernel/test_kprobes.c
> +++ b/kernel/test_kprobes.c
> @@ -115,7 +115,7 @@ static int test_kprobes(void)
>        int ret;
>        struct kprobe *kps[2] = {&kp, &kp2};
>
> -       kp.addr = 0; /* addr should be cleard for reusing kprobe. */
> +       kp.addr = NULL; /* addr should be cleard for reusing kprobe. */
>        ret = register_kprobes(kps, 2);
>        if (ret < 0) {
>                printk(KERN_ERR "Kprobe smoke test failed: "
> @@ -210,7 +210,7 @@ static int test_jprobes(void)
>        int ret;
>        struct jprobe *jps[2] = {&jp, &jp2};
>
> -       jp.kp.addr = 0; /* addr should be cleard for reusing kprobe. */
> +       jp.kp.addr = NULL; /* addr should be cleard for reusing kprobe. */
>        ret = register_jprobes(jps, 2);
>        if (ret < 0) {
>                printk(KERN_ERR "Kprobe smoke test failed: "
> @@ -323,7 +323,7 @@ static int test_kretprobes(void)
>        int ret;
>        struct kretprobe *rps[2] = {&rp, &rp2};
>
> -       rp.kp.addr = 0; /* addr should be cleard for reusing kprobe. */
> +       rp.kp.addr = NULL; /* addr should be cleard for reusing kprobe. */
>        ret = register_kretprobes(rps, 2);
>        if (ret < 0) {
>                printk(KERN_ERR "Kprobe smoke test failed: "
>
>
