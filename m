Return-Path: <linux-kernel-owner+w=401wt.eu-S1765680AbYCEIBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765680AbYCEIBt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 03:01:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764156AbYCEIAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 03:00:21 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33911
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1764068AbYCEIAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 03:00:20 -0500
Date: Wed, 05 Mar 2008 00:00:14 -0800 (PST)
Message-Id: <20080305.000014.245410231.davem@davemloft.net>
To: dmantipov@yandex.ru
Cc: linux-kernel@vger.kernel.org
Subject: Re: Are Linux pipes slower than the FreeBSD ones ?
From: David Miller <davem@davemloft.net>
In-Reply-To: <1389671204703217@webmail34.yandex.ru>
References: <1389671204703217@webmail34.yandex.ru>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Antipov Dmitry <dmantipov@yandex.ru>
Date: Wed, 05 Mar 2008 10:46:57 +0300

> Despite of this obvious fact, recently I've tried to compare pipe
> performance on Linux and FreeBSD systems. Unfortunately, Linux
> results are poor - ~2x slower than FreeBSD. The detailed description
> of the test case, preparation, environment and results are located
> at http://213.148.29.37/PipeBench, and everyone are pleased to look
> at, reproduce, criticize, etc.

FreeBSD does page flipping into the pipe receiver, so rerun your test
case but have either the sender or the receiver make changes to
their memory buffer in between the read/write calls.

FreeBSD's scheme is only good for benchmarks, rather then real life.


