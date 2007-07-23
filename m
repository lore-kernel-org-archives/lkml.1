Return-Path: <linux-kernel-owner+w=401wt.eu-S932927AbXGWSip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932927AbXGWSip (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 14:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760012AbXGWSie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 14:38:34 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:33347 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756375AbXGWSid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 14:38:33 -0400
Subject: Re: [PATCH] release quicklist before free_page
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
In-Reply-To: <20070723182301.GA27789@elte.hu>
References: <20070723152129.036573829@mvista.com>
	 <1185208378.8197.20.camel@twins> <1185207979.2573.55.camel@imap.mvista.com>
	 <20070723182301.GA27789@elte.hu>
Content-Type: text/plain
Date: Mon, 23 Jul 2007 11:27:12 -0700
Message-Id: <1185215232.2573.72.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-23 at 20:23 +0200, Ingo Molnar wrote:
> 
> how about: "if you've got some time then please also add a few comments, 
> because the code was quite non-obvious to me and I misunderstood it when 
> I tried to fix it. Thanks."

Not exactly what I was thinking of .. More like,

"LOCKING NOTE: This code uses the fact that get_cpu_var disables
preemption to maintain cpu affinity during the call to free_page()
otherwise it might free pages on another cpu."

(btw, your comment above comes off very snide, which I don't appreciate.
I haven't done anything that remotely warrants that.)

Daniel

