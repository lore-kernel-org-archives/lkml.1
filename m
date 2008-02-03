Return-Path: <linux-kernel-owner+w=401wt.eu-S1752010AbYBCSXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010AbYBCSXZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 13:23:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750796AbYBCSXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 13:23:15 -0500
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:42505 "EHLO
	bh-buildlin1.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbYBCSXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 13:23:14 -0500
Message-ID: <47A6068D.9020905@panasas.com>
Date: Sun, 03 Feb 2008 20:23:09 +0200
From: Benny Halevy <bhalevy@panasas.com>
Organization: Panasas, Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: am kara <kara_am@yahoo.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: 
References: <642794.12747.qm@web45910.mail.sp1.yahoo.com>
In-Reply-To: <642794.12747.qm@web45910.mail.sp1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

am kara wrote:
> hello,
> 
> If kernel does kmap_atomic(temporary kernel mapping)
> on behalf of a process by a cpu, does the process will
> continue to run and no other process can be scheduled
> to switch it off?(till kunmap_atomic is done)

Effectively, kmap_atomic implementations call pagefault_disable
and that in turn is equivalent to preempt_disable()
so the answer to your question seems to be "yes".

Benny

