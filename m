Return-Path: <linux-kernel-owner+w=401wt.eu-S1751331AbZL1L0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751331AbZL1L0v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 06:26:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbZL1L0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 06:26:51 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57893 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbZL1L0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 06:26:50 -0500
Subject: Re: perf: counter and event question
From: Peter Zijlstra <peterz@infradead.org>
To: Tim Blechmann <tim@klingt.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4B389391.8050303@klingt.org>
References: <4B389391.8050303@klingt.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Dec 2009 12:26:13 +0100
Message-ID: <1261999573.7135.83.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-28 at 12:16 +0100, Tim Blechmann wrote:
> like it is impossible to sample instructions with a period of 1? 

Pretty much, imagine the cpu getting a trap every cycle.

In order to avoid the machine grinding to a halt, we've implemented a
throttle which defaults to 100k samples/s, anything over that will be
discarted.

