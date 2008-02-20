Return-Path: <linux-kernel-owner+w=401wt.eu-S1760544AbYBTCZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760544AbYBTCZM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 21:25:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753590AbYBTCY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 21:24:59 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50852 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753226AbYBTCY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 21:24:58 -0500
Message-ID: <47BB8F05.3050001@cn.fujitsu.com>
Date: Wed, 20 Feb 2008 10:23:01 +0800
From: Shi Weihua <shiwh@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/5] signal(x86_32): Improve the signal stack overflow
 check
References: <47B95C4D.6080000@cn.fujitsu.com>	<20080218134720.GA28851@elte.hu>	<47BA299A.3040207@cn.fujitsu.com>	<20080219185009.122ED2701BA@magilla.localdomain>	<47BB7922.1010400@cn.fujitsu.com>	<20080220011822.C510B2701BA@magilla.localdomain>	<47BB83E2.1030504@cn.fujitsu.com> <20080220014419.B85D02701BA@magilla.localdomain>
In-Reply-To: <20080220014419.B85D02701BA@magilla.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath wrote::
>> You mean the comment?
> 
> No, that is trivial and already corrected.  I mean the substance of your
> most recent patch.  I described why I think it is wrong.  You did not respond.

I spent some time read you mail carefully and dig into the code again.

And yes, you are right. It's possible that SA_ONSTACK has been cleared
before the second signal on the same stack comes.

So this patch is wrong  :( . I will revise the other 4 patches.

Sorry for the noise.

