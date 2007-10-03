Return-Path: <linux-kernel-owner+w=401wt.eu-S1756204AbXJCN7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204AbXJCN7e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 09:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754534AbXJCN70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 09:59:26 -0400
Received: from [122.1.235.145] ([122.1.235.145]:62538 "EHLO
	smtp.wine.ocn.ne.jp" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754254AbXJCN7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 09:59:25 -0400
To: kaigai@kaigai.gr.jp
Cc: jmorris@namei.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, chrisw@sous-sol.org
Subject: Re: [TOMOYO 05/15](repost) Domain transition handler functions.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200710032024.DJF78662.FHOLtMSFOOFJVQ@I-love.SAKURA.ne.jp>
	<20071003.204356.05853536.yoshfuji@linux-ipv6.org>
	<Xine.LNX.4.64.0710030529580.6431@us.intercode.com.au>
	<200710032204.DFF51552.OFOSOFMVQtHLJF@I-love.SAKURA.ne.jp>
	<470395B3.2020904@kaigai.gr.jp>
In-Reply-To: <470395B3.2020904@kaigai.gr.jp>
Message-Id: <200710032259.HJF90663.OFMLOJtQHOFVSF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Wed, 3 Oct 2007 22:59:22 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

KaiGai Kohei wrote:
> If so, you can apply RCU instead to avoid read lock
> when scanning the list, like:
> 
> rcu_read_lock();
> list_for_each_entry(...) {
>      ....
> }
> rcu_read_unlock();

Can I sleep between rcu_read_lock() and rcu_read_unlock() ?
As far as I saw, rcu_read_lock() makes in_atomic() true, so I think I can't sleep.

If I use RCU, I have to give up " [TOMOYO 13/15] Conditional permission support"
because tmy_check_condition() can sleep.

Regards.

