Return-Path: <linux-kernel-owner+w=401wt.eu-S1756678AbYCBRPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678AbYCBRPz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 12:15:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755003AbYCBRPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 12:15:44 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:35297 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805AbYCBRPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 12:15:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=p1gP2e3Uj4Kh5FpBZq0RKkn7XGx2zHFEYis/mDBYUg3D8ijF0TZZym0r+eg4yrME257v8UPywOz3LmdW+b0nFmauGxoCRpqYvD5UhrTesUMt2VNuIkWSYj8Ncug/dxdF+wQGAnEKy8COFVAtinVLdB2jZIg9FFySnTbXE5rGL18=
Message-ID: <2c0942db0803020915y438bd922h8022267f6f7914fe@mail.gmail.com>
Date: Sun, 2 Mar 2008 09:15:41 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "=?UTF-8?Q?Ilpo_J=C3=A4rvinen?=" <ilpo.jarvinen@helsinki.fi>
Subject: Re: assertion (packets <= tp->packets_out) failed
Cc: "kernel list" <linux-kernel@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0803021041560.17707@kivilampi-30.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <2c0942db0803011510s5cfc30cbhee8ac9c1b849a2aa@mail.gmail.com>
	 <Pine.LNX.4.64.0803021041560.17707@kivilampi-30.cs.helsinki.fi>
X-Google-Sender-Auth: 134bd63f18e6a089
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m22HG5nq001869

On Sun, Mar 2, 2008 at 12:44 AM, Ilpo JÃ¤rvinen<ilpo.jarvinen@helsinki.fi> wrote:> On Sat, 1 Mar 2008, Ray Lee wrote:>>  > Wireless below is b43, wired interface (tg3) was disconnected. I run>  > openvpn which uses a tun interface and regularly sends a heartbeat>  > even when not in use. The trace appeared twice.>  >>  > Likely unrelated but reporting just for completeness: about fifteen>  > minutes after this the system oopsed when I told my wireless base>  > station to switch from mixed B/G to just B. I'll be taking that up>  > separately with the bcm43xx list.>  >>  > Mar  1 11:06:37 phoenix kernel: [35251.208275] eth1: switched to short>  > barker preamble (BSSID=00:16:01:d1:44:3e)>  > Mar  1 11:06:37 phoenix kernel: [35251.320282] eth1: switched to long>  > barker preamble (BSSID=00:16:01:d1:44:3e)>  > Mar  1 11:08:28 phoenix kernel: [35274.396163] KERNEL: assertion>  > (packets <= tp->packets_out) failed at net/ipv4/tcp_input.c (2139)>  > Mar  1 11:08:29 phoenix kernel: [35274.406126] ------------[ cut here>  > ]------------>  > Mar  1 11:08:29 phoenix kernel: [35274.406132] WARNING: at>  > net/ipv4/tcp_input.c:2506 tcp_ack+0xe3f/0x1b12()>>  Do people ever look into archives before posting? I'm a bit tired of point>  to the debug patch:>>  http://marc.info/?l=linux-kernel&m=120418703023153&w=2
I'm sorry, I managed to miss it. I'll apply the patch and report back.
Thank you.ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
