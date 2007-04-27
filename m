Return-Path: <linux-kernel-owner+w=401wt.eu-S1756069AbXD0Qe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069AbXD0Qe1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 12:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756068AbXD0Qe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 12:34:27 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:23923 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756058AbXD0QeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 12:34:25 -0400
Subject: Re: [PATCH 1/3] ia64: convert to use clocksource code
From: Daniel Walker <dwalker@mvista.com>
To: Peter Keilty <peter.keilty@hp.com>
Cc: linux-ia64@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
       Eric Whitney <eric.whitney@hp.com>, linux-kernel@vger.kernel.org
In-Reply-To: <463220C8.5060408@hp.com>
References: <20070426202632.23343.54944.sendpatchset@rambler.zko.hp.com>
	 <1177621673.12796.121.camel@imap.mvista.com>  <46320ACD.6090704@hp.com>
	 <1177688158.12796.125.camel@imap.mvista.com>  <463219CD.5040203@hp.com>
	 <1177688931.12796.130.camel@imap.mvista.com>  <463220C8.5060408@hp.com>
Content-Type: text/plain
Date: Fri, 27 Apr 2007 09:32:55 -0700
Message-Id: <1177691575.12796.142.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-27 at 12:11 -0400, Peter Keilty wrote:

> >
> No, but yes it can be done, overloading the meaning.
> It would need to change in the future if vread was needed.
> I have no strong argument against  using it.
> Although we may still need the IA64 define, I removed 32bit read mmio and
> if that is brought back the fast syscall patch call will need to have a 
> field in the
> clocksource struct that would indicated that. Waiting on comments about 
> that...
> John and discuss this awhile back felt it was not needed, may prove wrong.

The vread field is just a pointer, which should be 64bits on ia64. Why
do you mention 32bits above? The two variables similar enough .. 

Daniel

