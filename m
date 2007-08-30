Return-Path: <linux-kernel-owner+w=401wt.eu-S933140AbXH3TY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933140AbXH3TY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 15:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759281AbXH3TYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 15:24:17 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:41942 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758521AbXH3TYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 15:24:17 -0400
Date: Thu, 30 Aug 2007 21:24:16 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: Joe Perches <joe@perches.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] trivial - constify sched.h
In-Reply-To: <20070827213323.GA1759@martell.zuzino.mipt.ru>
Message-ID: <Pine.LNX.4.64.0708302120290.24730@fbirervta.pbzchgretzou.qr>
References: <1188247231.18004.129.camel@localhost> <20070827213323.GA1759@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 28 2007 01:33, Alexey Dobriyan wrote:
>
>On Mon, Aug 27, 2007 at 01:40:31PM -0700, Joe Perches wrote:
>> Add const to some struct task_struct * uses
>
>Why, oh, why?


So that you can actually pass in a const struct task_struct * without having
to cast it back to [non-const].

Why one would have a const struct task_struct * in the first place
is a different matter.

But see http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=77adbfbf4cf96fedf9b75bb330704828c187b190


	Jan
-- 
