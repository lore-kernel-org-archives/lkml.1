Return-Path: <linux-kernel-owner+w=401wt.eu-S933717AbXHFXh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933717AbXHFXh6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 19:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933107AbXHFXht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 19:37:49 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:53367 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932956AbXHFXhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 19:37:48 -0400
Message-Id: <1186443467.11680.1204059001@webmail.messagingengine.com>
X-Sasl-Enc: kddQPztPo1hM2irdGDFpLQCYe/G7KKSwlEEgt3YZ5mRm 1186443467
From: "Adam M" <lkml@irotas.net>
To: linux-kernel@vger.kernel.org
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
Subject: Creating virtual interface triggers an IGMPv3 Join to Multicast DNS
Date: Mon, 06 Aug 2007 19:37:47 -0400
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

For some reason, every time I create a virtual interface (using tun),
the interface immediately generates an IGMPv3 Join packet for group
224.0.0.251, which (according to Google) is Multicast DNS.

This packet is generated automatically and consistently. I'm wondering
why this should be the case, and if it can be disabled.

Thanks,
Adam
