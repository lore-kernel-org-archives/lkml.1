Return-Path: <linux-kernel-owner+w=401wt.eu-S1758651AbYENPGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758651AbYENPGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 11:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757559AbYENPGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 11:06:36 -0400
Received: from bay0-omc1-s28.bay0.hotmail.com ([65.54.246.100]:29494 "EHLO
	bay0-omc1-s28.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757366AbYENPGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 11:06:36 -0400
Message-ID: <BAY103-DAV9C4667C3BA5764E61DA2CB2CE0@phx.gbl>
X-Originating-IP: [85.32.103.134]
X-Originating-Email: [pupilla@hotmail.com]
From: "Marco Berizzi" <pupilla@hotmail.com>
To: <linux-kernel@vger.kernel.org>
Subject: v2.6.25: SKB BUG: Invalid truesize (260) len=134, sizeof(sk_buff)=164
Date: Wed, 14 May 2008 17:04:03 +0200
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1123
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1123
X-OriginalArrivalTime: 14 May 2008 15:06:35.0508 (UTC) FILETIME=[1A111340:01C8B5D4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks.
After 20 days uptime linux 2.6.25 has
started logging a ton of these messages:

May 14 17:00:23 Pleiadi kernel: SKB BUG: Invalid truesize (260) len=134,
sizeof(sk_buff)=164
May 14 17:00:23 Pleiadi kernel: SKB BUG: Invalid truesize (260) len=118,
sizeof(sk_buff)=164
May 14 17:00:23 Pleiadi kernel: SKB BUG: Invalid truesize (324) len=166,
sizeof(sk_buff)=164
May 14 17:00:23 Pleiadi kernel: SKB BUG: Invalid truesize (324) len=166,
sizeof(sk_buff)=164
May 14 17:00:23 Pleiadi kernel: SKB BUG: Invalid truesize (260) len=118,
sizeof(sk_buff)=164
May 14 17:00:23 Pleiadi kernel: SKB BUG: Invalid truesize (260) len=118,
sizeof(sk_buff)=164
May 14 17:00:23 Pleiadi kernel: SKB BUG: Invalid truesize (292) len=166,
sizeof(sk_buff)=164
May 14 17:00:23 Pleiadi kernel: SKB BUG: Invalid truesize (324) len=166,
sizeof(sk_buff)=164
May 14 17:00:23 Pleiadi kernel: SKB BUG: Invalid truesize (324) len=166,
sizeof(sk_buff)=164
May 14 17:00:24 Pleiadi kernel: SKB BUG: Invalid truesize (260) len=118,
sizeof(sk_buff)=164

Does it mean there is a problem?


