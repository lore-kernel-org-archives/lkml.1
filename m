Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955Ab0BPOka (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 09:40:30 -0500
Received: from mail-forward1.uio.no ([129.240.10.70]:39185 "EHLO
	mail-forward1.uio.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab0BPOk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 09:40:28 -0500
Message-ID: <4B7AAE52.5050507@simula.no>
Date: Tue, 16 Feb 2010 15:40:18 +0100
From: Andreas Petlund <apetlund@simula.no>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9pre) Gecko/20100209 Shredder/3.0.2pre
MIME-Version: 1.0
To: "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Arnd Hannemann <hannemann@nets.rwth-aachen.de>,
       LKML <linux-kernel@vger.kernel.org>, shemminger@vyatta.com,
       David Miller <davem@davemloft.net>, william.allen.simpson@gmail.com,
       damian@tvk.rwth-aachen.de, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [net-next PATCH v4 0/3] net: TCP thin-stream latency-improving modifications
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 10 msgs/h 1 sum rcpts/h 13 sum msgs/h 2 total rcpts 822 max rcpts/h 37 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 273D20FB95B3134973A45B1CD8D7DCF562228717
X-UiO-SPAM-Test: remote_host: 128.39.37.254 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 17 total 20207 max/h 66 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a series of patches enabling non-intrusive, dynamically triggered modifications that improve retransmission latencies for thin streams.

The patch set was modified according to the feedback received.

Major changes:
      -Renamed central variables, sysctls and ioctls.
      -Removed redundant allocations.
      -Added documentation in ip-sysctl.txt.
      -Added tcp thin-stream info in new file: tcp-thin.txt.

Cheers,
Andreas Petlund
