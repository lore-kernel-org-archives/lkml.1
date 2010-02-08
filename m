Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab0BHPEz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 10:04:55 -0500
Received: from mail-forward2.uio.no ([129.240.10.71]:56045 "EHLO
	mail-forward2.uio.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170Ab0BHPEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 10:04:43 -0500
Message-ID: <4B701ED6.5000800@simula.no>
Date: Mon, 08 Feb 2010 15:25:26 +0100
From: Andreas Petlund <apetlund@simula.no>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Arnd Hannemann <hannemann@nets.rwth-aachen.de>,
       LKML <linux-kernel@vger.kernel.org>, shemminger@vyatta.com,
       David Miller <davem@davemloft.net>, william.allen.simpson@gmail.com
Subject: [net-next PATCH v2 0/3] net: TCP thin-stream latency-improving modifications
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 8 msgs/h 1 sum rcpts/h 8 sum msgs/h 1 total rcpts 725 max rcpts/h 37 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: C07037066463A921871DDF333D642C70AD36F5DA
X-UiO-SPAM-Test: remote_host: 128.39.37.254 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 12 total 18726 max/h 66 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a series of patches enabling non-intrusive, dynamically triggered modifications that improves retransmission latencies for thin streams.

We have modified the patches according to the feedback from the last round of discussions.

Links to discussions about v1 of the patch set:
http://thread.gmane.org/gmane.linux.network/141394
http://thread.gmane.org/gmane.linux.network/141395
http://thread.gmane.org/gmane.linux.network/141396
http://thread.gmane.org/gmane.linux.network/141397

More information about the mechanics of the modifications, as well as extensive test results can be found here:
http://simula.no/research/nd/publications/Simula.nd.477/simula_pdf_file

Cheers,
Andreas Petlund


