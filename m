Return-Path: <linux-kernel-owner+w=401wt.eu-S1759029AbYC0L7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759029AbYC0L7e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 07:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756745AbYC0L7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 07:59:16 -0400
Received: from public.bindows.net ([66.135.40.169]:41085 "EHLO
	public.bindows.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756542AbYC0L7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 07:59:15 -0400
Message-ID: <47EB8C06.4030306@better.se>
Date: Thu, 27 Mar 2008 12:59:02 +0100
From: Marcus Better <marcus@better.se>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
Cc: a.p.zijlstra@chello.nl, akpm@linux-foundation.org, jarkao2@gmail.com,
       netdev@vger.kernel.org, bugme-daemon@bugzilla.kernel.org,
       shemminger@linux-foundation.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [Bugme-new] [Bug 10326] New: inconsistent lock state in net_rx_action
References: <20080327085542.GA2778@ami.dom.local>	<20080327021812.601776b8.akpm@linux-foundation.org>	<1206615379.8514.502.camel@twins> <20080327.040334.25440988.davem@davemloft.net>
In-Reply-To: <20080327.040334.25440988.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> Can some test if using local_irq_{save,restore}() in
> napi_complete() cures this lockdep warning?

I cannot reproduce the bug, so cannot help much.

Marcus

