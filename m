Return-Path: <linux-kernel-owner+w=401wt.eu-S1759733AbYBGRJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759733AbYBGRJn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 12:09:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755624AbYBGRJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 12:09:35 -0500
Received: from sj-iport-4.cisco.com ([171.68.10.86]:42383 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094AbYBGRJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 12:09:34 -0500
X-IronPort-AV: E=Sophos;i="4.25,316,1199692800"; 
   d="scan'208";a="5364882"
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Plans for d0049e71 ("x86: make io_delay=0xed the default")
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 07 Feb 2008 09:09:24 -0800
Message-ID: <ada8x1wbsmz.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 07 Feb 2008 17:09:24.0651 (UTC) FILETIME=[30594FB0:01C869AC]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

What are your plans for handling the x86 io_delay stuff?  The current
situation is pretty confusing to someone updating their config from a
2.6.24 kernel, since arch/x86/Kconfig.debug has:

config IO_DELAY_0X80
	bool "port 0x80 based port-IO delay [recommended]"

but also

choice
	prompt "IO delay type"
	default IO_DELAY_0XED

so the IO delay type defaults to something different than the
recommended value.

 - R.
