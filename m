Return-Path: <linux-kernel-owner+w=401wt.eu-S1759067AbYHTQJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759067AbYHTQJg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 12:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755448AbYHTQJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 12:09:27 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:60067 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755058AbYHTQJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 12:09:26 -0400
Date: Wed, 20 Aug 2008 20:13:56 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: [PATCH -mm 0/2] posix-timers: use struct pid*
Message-ID: <20080820161356.GA1401@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't like the fact that the first patch complicates the code.
Hopefully not too much though. I am asking for the explicit ack/nack
even if it is correct.

good_sigevent() wasn't pretty, and it is uglified even more. I'll send
a separate cleanup later.

Oleg.

