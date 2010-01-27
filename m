Return-Path: <linux-kernel-owner+w=401wt.eu-S1754768Ab0A0CXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab0A0CXX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 21:23:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754711Ab0A0CXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 21:23:20 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:19414 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754692Ab0A0CXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 21:23:19 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtQAADYwX0tLd/sX/2dsb2JhbAAIg0DHEIIUAY1IgSmCNlgE
X-IronPort-AV: E=Sophos;i="4.49,350,1262581200"; 
   d="scan'208";a="54634880"
Message-ID: <4B5FA147.5040802@teksavvy.com>
Date: Tue, 26 Jan 2010 21:13:27 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>, Mel Gorman <mel@csn.ul.ie>
Subject: 2.6.32.5 regression: page allocation failure. order:1,
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I recently upgraded our 24/7 server from 2.6.31.5 to 2.6.32.5.

Now, suddenly the logs are full of "page allocation failure. order:1",
and the odd "page allocation failure. order:4" failures.

Wow.  WTF happened in 2.6.32 ???

Downgrading now.

Logs available if you want them:  http://rtr.ca/2.6.32_page_alloc_fail_logs.txt

--
Mark Lord
