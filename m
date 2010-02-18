Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257Ab0BRMmX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 07:42:23 -0500
Received: from mail-forward1.uio.no ([129.240.10.70]:41134 "EHLO
	mail-forward1.uio.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758230Ab0BRMmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 07:42:22 -0500
Message-ID: <4B7D35A5.10106@simula.no>
Date: Thu, 18 Feb 2010 13:42:13 +0100
From: Andreas Petlund <apetlund@simula.no>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9pre) Gecko/20100209 Shredder/3.0.2pre
MIME-Version: 1.0
To: Netdev <netdev@vger.kernel.org>
CC: =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       eric.dumazet@gmail.com, hannemann@nets.rwth-aachen.de,
       LKML <linux-kernel@vger.kernel.org>, shemminger@vyatta.com,
       william.allen.simpson@gmail.com, damian@tvk.rwth-aachen.de,
       ebiederm@xmission.com, David Miller <davem@davemloft.net>,
       Franco Fichtner <franco@lastsummer.de>
Subject: [net-next PATCH v5 0/3] net: TCP thin-stream latency-improving modifications
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 11 msgs/h 1 sum rcpts/h 23 sum msgs/h 2 total rcpts 900 max rcpts/h 40 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 183B94311E0204DE849C8882316EEDC1399CD02C
X-UiO-SPAM-Test: remote_host: 128.39.37.254 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 22 total 20752 max/h 66 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a series of patches enabling non-intrusive, dynamically 
triggered modifications that improve retransmission latencies 
for thin streams.

The patch set was modified according to the feedback received.

Major change:
      -Used bitfields to compact the nonagle variable
       in the tcp_sock struct. nonagle, thin_lto and
       thin_dupack is now contained in the same u8.

I decided to use bitfields to handle this as it is
already done similarly in the tcp_options_received struct.

Also corrected some formatting issues.

Cheers,
Andreas Petlund
