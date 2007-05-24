Return-Path: <linux-kernel-owner+w=401wt.eu-S1751560AbXEXRKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560AbXEXRKb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 13:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750729AbXEXRKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 13:10:21 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:59618 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbXEXRKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 13:10:20 -0400
To: mingo@elte.hu
CC: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       tglx@linutronix.de
In-reply-to: <20070524144447.GA25068@elte.hu> (message from Ingo Molnar on
	Thu, 24 May 2007 16:44:49 +0200)
Subject: Re: [BUG] long freezes on thinkpad t60
References: <E1HrC3W-0005SZ-00@dorka.pomaz.szeredi.hu> <20070524125453.GA7554@elte.hu> <E1HrDuQ-0005m7-00@dorka.pomaz.szeredi.hu> <20070524141059.GA19872@elte.hu> <E1HrEIp-0005qy-00@dorka.pomaz.szeredi.hu> <20070524144447.GA25068@elte.hu>
Message-Id: <E1HrGom-0006AC-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 24 May 2007 19:09:40 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> could you just try v2.6.21 plus the -rt patch, which has the tracer 
> built-in? That's a combination that should work well. You can pick it up 
> from:
> 
>    http://people.redhat.com/mingo/realtime-preempt/
> 
> same config options as above. If you dont turn on PREEMPT_RT you'll get 
> an almost-vanilla kernel.

2.6.22-rc2, only EVENT_TRACE - boots, can't rerpoduce
2.6.21-vanila - can reproduce
2.6.21-rt7, trace options off - can reproduce
2.6.21-rt7, trace options on - can't reproduce

Possibly something timing related, that's altered by the trace code.
I tried the trace kernel without starting the trace app, but still no
bug.

Any other ideas?

Thanks,
Miklos
