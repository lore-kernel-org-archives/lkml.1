Return-Path: <linux-kernel-owner+w=401wt.eu-S1752485AbZAFMDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485AbZAFMDq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 07:03:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbZAFMDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 07:03:37 -0500
Received: from gate.crashing.org ([63.228.1.57]:45690 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436AbZAFMDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 07:03:37 -0500
Subject: Re: Lock-up on PPC64
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: malc <av1474@comtv.ru>
Cc: Michael Ellerman <michael@ellerman.id.au>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0901051928200.2208@linmac.oyster.ru>
References: <Pine.LNX.4.64.0812212058550.2164@linmac.oyster.ru>
	 <20081222233223.GA6688@joi> <877i5rh9rm.fsf@linmac.oyster.ru>
	 <20081223234513.GA8730@deepthought> <871vvy77v4.fsf@linmac.oyster.ru>
	 <1230165163.7292.32.camel@pasglop>
	 <Pine.LNX.4.64.0812280335070.2526@linmac.oyster.ru>
	 <1231158516.8367.3.camel@localhost>
	 <Pine.LNX.4.64.0901051928200.2208@linmac.oyster.ru>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 23:02:53 +1100
Message-Id: <1231243373.14860.24.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-05 at 19:34 +0300, malc wrote:
> Before this change (atleast) mono_handle_native_sigsegv was executed
> (before machine locks-up hard) after the change this code path is
> never touched.
> 
> The fact that machine locks up hard and not even magic sysrq works
> is what deserves a better look.

Indeed. It's possible that the normally not hit error case is triggering
a different bug. Definitely worth looking at.

I didn't have a chance so far, I'm a bit swamped at the moment, but keep
pining me please :-)

Cheers,
Ben.


