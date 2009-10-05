Return-Path: <linux-kernel-owner+w=401wt.eu-S1758524AbZJEN3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758524AbZJEN3M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 09:29:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756594AbZJEN3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 09:29:11 -0400
Received: from www.tglx.de ([62.245.132.106]:44676 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbZJEN3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 09:29:11 -0400
Date: Mon, 5 Oct 2009 15:28:16 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Anirban Sinha <ani@anirban.org>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Darren Hart <dvhltc@us.ibm.com>,
       Kaz Kylheku <kaz@zeugmasystems.com>,
       Anirban Sinha <asinha@zeugmasystems.com>
Subject: Re: futex question
In-Reply-To: <4AC9F06B.8020708@anirban.org>
Message-ID: <alpine.LFD.2.00.0910051525560.2646@localhost.localdomain>
References: <DDFD17CC94A9BD49A82147DDF7D545C501FD7F97@exchange.ZeugmaSystems.local>  <20091001092218.GH15345@elte.hu>  <DDFD17CC94A9BD49A82147DDF7D545C501FD8409@exchange.ZeugmaSystems.local>  <4AC68F13.8050601@us.ibm.com>  <alpine.LFD.2.00.0910041031330.2646@localhost.localdomain>
  <DDFD17CC94A9BD49A82147DDF7D545C501F457C5@exchange.ZeugmaSystems.local>  <4AC8CF32.8060108@anirban.org>  <alpine.LFD.2.00.0910041853180.2646@localhost.localdomain>  <1254738974.26976.24.camel@twins>  <alpine.LFD.2.00.0910051251080.2646@localhost.localdomain>
 <1254741372.26976.35.camel@twins> <alpine.LFD.2.00.0910051346230.2646@localhost.localdomain> <4AC9F06B.8020708@anirban.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you please fix your mail client to do proper line breaks at around
78 chars ?

On Mon, 5 Oct 2009, Anirban Sinha wrote:
>
> We need to clear those pointers regardless. After the exceve(), the
> address values are meaningless under the new mm context.

That's out of question. We just need to come to a decision whether we
silently clean up callers dumbness or not.

Thanks,

	tglx
