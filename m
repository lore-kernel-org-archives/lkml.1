Return-Path: <linux-kernel-owner+w=401wt.eu-S1751930AbZLAFBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930AbZLAFBF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 00:01:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750843AbZLAFBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 00:01:03 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32805
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750811AbZLAFBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 00:01:03 -0500
Date: Mon, 30 Nov 2009 21:01:08 -0800 (PST)
Message-Id: <20091130.210108.257061035.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: firefighterblu3@gmail.com, linux-kernel@vger.kernel.org,
       david@blue-labs.org, netdev@vger.kernel.org
Subject: Re: NULL pointer dereference at
 2.6.32-rc8:net/ipv4/ip_fragment.c:566
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091201043759.GA22655@gondor.apana.org.au>
References: <523e55a00911250152n773f2cbeu9251180c44f0b9a@mail.gmail.com>
	<20091201043759.GA22655@gondor.apana.org.au>
X-Mailer: Mew version 6.2 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Tue, 1 Dec 2009 12:37:59 +0800

> David Ford <firefighterblu3@gmail.com> wrote:
>>
>> hmm.  that shows a patch of code which is just prior to ip_defrag(), i.e.:
>> 
>>    565 out_fail:
>>    566         IP_INC_STATS_BH(dev_net(dev), IPSTATS_MIB_REASMFAILS);
> 
> Looks like a namespace problem.
> 
> Please open a bug report on bugzilla.kernel.org to ensure that
> this is tracked.

Herbert, David posted a patch to fix this which went into my tree the
other day and now has reached Linus's tree as well.
