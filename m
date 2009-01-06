Return-Path: <linux-kernel-owner+w=401wt.eu-S1753675AbZAFVSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675AbZAFVSW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 16:18:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751312AbZAFVSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 16:18:14 -0500
Received: from gate.crashing.org ([63.228.1.57]:35978 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbZAFVSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 16:18:12 -0500
Subject: Re: Lock-up on PPC64
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: malc <av1474@comtv.ru>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0901062032550.2972@linmac.oyster.ru>
References: <Pine.LNX.4.64.0812212058550.2164@linmac.oyster.ru>
	 <20081222233223.GA6688@joi> <877i5rh9rm.fsf@linmac.oyster.ru>
	 <20081223234513.GA8730@deepthought> <871vvy77v4.fsf@linmac.oyster.ru>
	 <1230165163.7292.32.camel@pasglop>
	 <Pine.LNX.4.64.0812280335070.2526@linmac.oyster.ru>
	 <1231158516.8367.3.camel@localhost>
	 <Pine.LNX.4.64.0901051928200.2208@linmac.oyster.ru>
	 <1231243373.14860.24.camel@pasglop>
	 <Pine.LNX.4.64.0901062032550.2972@linmac.oyster.ru>
Content-Type: text/plain
Date: Wed, 07 Jan 2009 08:17:23 +1100
Message-Id: <1231276643.14860.30.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> As you wish :) I've written some ad-hoc stuff in the failing path which 
> manually triggers sysrq and then sends the klogctl output via network
> and here it is:

Allright, something's unclear to me. What do you mean by the system goes
down then ? The kernel appears to be working at least to a certain
extent if you manage to trigger a sysrq from userspace... And from what
I see, it looks that all processes are somewhere in schedule.

So what is precisely your symptom here ?

Cheers,
Ben.


