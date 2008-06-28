Return-Path: <linux-kernel-owner+w=401wt.eu-S1758234AbYF1Orm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234AbYF1Orm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 10:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbYF1Orf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 10:47:35 -0400
Received: from eth7959.sa.adsl.internode.on.net ([150.101.82.22]:46512 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752567AbYF1Ore (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 10:47:34 -0400
Message-ID: <48664F01.7060902@davidnewall.com>
Date: Sun, 29 Jun 2008 00:17:29 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Martin Lucina <mato@kotelna.sk>
CC: linux-kernel@vger.kernel.org, Martin Sustrik <sustrik@fastmq.com>
Subject: Re: Higher than expected disk write(2) latency
References: <20080628121131.GA14181@nodbug.moloch.sk>
In-Reply-To: <20080628121131.GA14181@nodbug.moloch.sk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Lucina wrote:
> Measurement of the write(2) time is performed using the TSC, so any
> latency there is negligible.

Measuring each write is lavish and bound to impact the results.  To
measure sustained throughput, get the time only at start and end, and
divide the difference by the number of writes.
