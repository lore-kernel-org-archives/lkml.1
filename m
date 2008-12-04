Return-Path: <linux-kernel-owner+w=401wt.eu-S1754866AbYLDMdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866AbYLDMdV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 07:33:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbYLDMdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 07:33:09 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:29517 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbYLDMdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 07:33:07 -0500
Subject: Re: RFC: Latency reducing TCP modifications for thin-stream
 interactive applications
From: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
To: Andreas Petlund <apetlund@simula.no>
Cc: linux-kernel@vger.kernel.org,
       linux-rt-users <linux-rt-users@vger.kernel.org>
In-Reply-To: <492EA31D.8000704@simula.no>
References: <492EA31D.8000704@simula.no>
Content-Type: text/plain
Date: Thu, 04 Dec 2008 04:15:50 -0800
Message-Id: <1228392950.9704.4.camel@sven.thebigcorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-27 at 14:39 +0100, Andreas Petlund wrote:

Hi -

Just a minor nit (trying your patch on a 2.6.22 Kernel):

These little white space tweaks are to be avoided, adding to the patch
size unnecessarily.

Do you have a version against 2.6.28, or Linux-tip?

Regards,

Sven

>                 }
> -
> +               
>                 /* Initial outgoing SYN's get put onto the write_queue
>                  * just like anything else we transmit.  It is not
>                  * true data, and if we misinform our callers that
> @@ -2479,14 +2585,14 @@
>                         acked |= FLAG_SYN_ACKED;
>                         tp->retrans_stamp = 0;
>                 }
> -
> +               
>                 /* MTU probing checks */
>                 if (icsk->icsk_mtup.probe_size) {
>                         if (!after(tp->mtu_probe.probe_seq_end,
> TCP_SKB_CB(skb)->end_seq)) {
>                                 tcp_mtup_probe_success(sk, skb);
>                         }
>                 }
> -
> +               
>                 if (sacked) {
>                         if (sacked & TCPCB_RETRANS) {
>                                 if (sacked & TCPCB_SACKED_RETRANS)
> @@ -2510,24 +2616,32 @@

