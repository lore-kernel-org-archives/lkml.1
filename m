Return-Path: <linux-kernel-owner+w=401wt.eu-S935013AbXEVSSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935013AbXEVSSK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 14:18:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759042AbXEVSR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 14:17:57 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:16165 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757101AbXEVSR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 14:17:56 -0400
X-IronPort-AV: i="4.14,567,1170651600"; 
   d="scan'208"; a="39727021:sNHT24953138"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: ./scripts/kallsysm.c question
Date: Tue, 22 May 2007 14:20:26 -0400
User-Agent: KMail/1.9.5
Cc: "LKML" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705221420.26693.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 22 May 2007 18:17:54.0888 (UTC) FILETIME=[846CF480:01C79C9D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam:

I was noticing some issues with /proc/kallsyms generation on our platform, 
which I noticed after a toolchain update (which I fixed)

However, I had a question in looking at the logic - it looks like the out 
function puts out all symbols - even if they are in the _init section. My
question was should it?

I can see some issues if someone built a module against a function that was
marked as init - when the module loaded - the init code is gone, but the 
symbol is still in the kernel - isn't it? a module would jump to where the
code use to be - which might be something else at the time.

-Robin
