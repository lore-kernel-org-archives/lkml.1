Return-Path: <linux-kernel-owner+w=401wt.eu-S1752644AbYCOFFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbYCOFFS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 01:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751273AbYCOFFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 01:05:05 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:59627 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257AbYCOFFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 01:05:04 -0400
Subject: Re: [PATCH 4/5]  ntp.c code flow clenaups  (from Ingo)
From: John Stultz <johnstul@us.ibm.com>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <Pine.LNX.4.64.0803150551020.1791@scrub.home>
References: <1205553852.6122.76.camel@localhost.localdomain>
	 <1205553938.6122.79.camel@localhost.localdomain>
	 <1205554018.6122.81.camel@localhost.localdomain>
	 <1205554210.6122.85.camel@localhost.localdomain>
	 <1205554366.6122.88.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0803150551020.1791@scrub.home>
Content-Type: text/plain
Date: Fri, 14 Mar 2008 22:04:56 -0700
Message-Id: <1205557496.6173.2.camel@jstultz-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-03-15 at 05:52 +0100, Roman Zippel wrote:
> Hi,
> 
> On Fri, 14 Mar 2008, john stultz wrote:
> 
> > +static inline void process_adjtimex_adj_offset(struct timex *txc, long sec)
> 
> Somewhat ugly name...

Oh, that's a mis-merge. Thanks for catching it. The name should have
been: process_adjtimex_modes().

process_adjtimex_adj_offset was basically the same as your
ntp_update_offset() function, so I killed it but grabbed the wrong
function name.

> From an userspace perspective it's the core of ntp_adjtime(), so I'd 
> prefer something close to that.

does process_adjtimex_modes(), or ntp_process_adjtimex_modes work for
you?

thanks
-john


