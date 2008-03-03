Return-Path: <linux-kernel-owner+w=401wt.eu-S1758140AbYCCIIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140AbYCCIIe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 03:08:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbYCCII1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 03:08:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39033 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751841AbYCCII1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 03:08:27 -0500
Date: Mon, 3 Mar 2008 00:07:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Cc: zippel@linux-m68k.org, linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
       mingo@elte.hu, tglx@linutronix.de
Subject: Re: [PATCH v2] Remove obsolete CLOCK_TICK_ADJUST
Message-Id: <20080303000725.dd73760a.akpm@linux-foundation.org>
In-Reply-To: <360162.3798.qm@web52011.mail.re2.yahoo.com>
References: <360162.3798.qm@web52011.mail.re2.yahoo.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Mar 2008 22:48:45 -0800 (PST) Matti Linnanvuori <mattilinnanvuori@yahoo.com> wrote:

> --- a/kernel/time/ntp.c~time-remove-obsolete-clock_tick_adjust
> +++ a/kernel/time/ntp.c
> @@ -42,12 +42,13 @@ long time_esterror = NTP_PHASE_LIMIT; /*
>  long time_freq;    /* frequency offset (scaled ppm)*/
>  static long time_reftime;  /* time at last adjustment (s) */
>  long time_adjust;
> +static long ntp_tick_adj;
>  
>  static void ntp_update_frequency(void)
>  {
>   u64 second_length = (u64)(tick_usec * NSEC_PER_USEC * USER_HZ)
>      << TICK_LENGTH_SHIFT;
> - second_length += (s64)CLOCK_TICK_ADJUST << TICK_LENGTH_SHIFT;
> + second_length += (s64)ntp_tick_adj << TICK_LENGTH_SHIFT;
>   second_length += (s64)time_freq << (TICK_LENGTH_SHIFT - SHIFT_NSEC);
>  

your email client has converted the tabs into single-spaces.
