Return-Path: <linux-kernel-owner+w=401wt.eu-S1763240AbZANP2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763240AbZANP2l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 10:28:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757188AbZANP2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 10:28:31 -0500
Received: from wf-out-1314.google.com ([209.85.200.170]:46124 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757019AbZANP23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 10:28:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=rpFHIsQU4Fb7OV13nZC2CZ2AqIwc13D7ez+ISezq4h/NuImVuRacu9QZndXZIYwB0c
         L9SOI0qUsiGZhOuOF4rqsXe77LpWVM0bfK43OY77Yf/TulFGXVWRIIa52O+08WYR6kU4
         M+fFHUcSUS2AvtO9b2C5D7zrpbMqJddtMafmA=
MIME-Version: 1.0
In-Reply-To: <d6a046090901112338s66143f5ekd03d461027407cf4@mail.gmail.com>
References: <d6a046090901112338s66143f5ekd03d461027407cf4@mail.gmail.com>
Date: Wed, 14 Jan 2009 10:28:28 -0500
X-Google-Sender-Auth: 04b2b02761ebf988
Message-ID: <b6c5339f0901140728p71c0223apaa7dc27bc7371a7b@mail.gmail.com>
Subject: Re: ath5k related kernel panic in 2.6.29-rc1
From: Bob Copeland <me@bobcopeland.com>
To: "Sergey S. Kostyliov" <rathamahata@gmail.com>
Cc: linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 2:38 AM, Sergey S. Kostyliov
<rathamahata@gmail.com> wrote:

Thanks for the report!

Apologies, I haven't had time to look into this yet, so this
is just a response to the effect of "it's on my list."

> ------------[ cut here ]------------
> WARNING: at net/mac80211/tx.c:567 invoke_tx_handlers+0xdde/0xe30()
> Hardware name: Aspire 5100
> Modules linked in:
> Pid: 3508, comm: rsync Not tainted 2.6.29-rc1 #2
> Call Trace:
>  [<ffffffff8023e55a>] warn_slowpath+0xea/0x160
>  [<ffffffff8062f6ce>] invoke_tx_handlers+0xdde/0xe30
>  [<ffffffff8062e3b6>] __ieee80211_tx_prepare+0x196/0x310
>  [<ffffffff805933a0>] pskb_expand_head+0x110/0x180
>  [<ffffffff80630a1a>] ieee80211_master_start_xmit+0x20a/0x4c0
>  [<ffffffff805acb86>] __qdisc_run+0x226/0x270
>  [<ffffffff8059b8a0>] dev_queue_xmit+0x2a0/0x5b0
>  [<ffffffff806305b3>] ieee80211_subif_start_xmit+0x3b3/0x610
>  [<ffffffff805acb86>] __qdisc_run+0x226/0x270
>  [<ffffffff8059b8a0>] dev_queue_xmit+0x2a0/0x5b0
>  [<ffffffff805bf6ce>] ip_queue_xmit+0x22e/0x430
>  [<ffffffff802badc0>] pollwake+0x0/0x50
>  [<ffffffff805d2f7f>] tcp_transmit_skb+0x4bf/0x760
>  [<ffffffff805d54e9>] tcp_write_xmit+0x1f9/0xa40
>  [<ffffffff805d5d83>] __tcp_push_pending_frames+0x23/0x80
>  [<ffffffff805c89d5>] tcp_sendmsg+0x8b5/0xc00
>  [<ffffffff802bbee8>] dput+0xa8/0x170
>  [<ffffffff8058a677>] sock_aio_write+0x147/0x160
>  [<ffffffff802aa24b>] do_sync_write+0xdb/0x120
>  [<ffffffff80254e70>] autoremove_wake_function+0x0/0x30
>  [<ffffffff8025c128>] getnstimeofday+0x58/0xe0
>  [<ffffffff80258330>] ktime_get_ts+0x30/0x60
>  [<ffffffff802b9614>] poll_select_copy_remaining+0x104/0x160
>  [<ffffffff802aacfe>] vfs_write+0x15e/0x170
>  [<ffffffff802aae13>] sys_write+0x53/0xa0
>  [<ffffffff8020ba1b>] system_call_fastpath+0x16/0x1b
> ---[ end trace bd3017b2640f5911 ]---

I think this is the "RC is busted" WARN_ON.  Other than that,
at this point I can't say much.

-- 
Bob Copeland %% www.bobcopeland.com
