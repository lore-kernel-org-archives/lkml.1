Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087AbZCQOkC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbZCQOkC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 10:40:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753278AbZCQOjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 10:39:51 -0400
Received: from Cpsmtpm-eml108.kpnxchange.com ([195.121.3.12]:61817 "EHLO
	CPSMTPM-EML108.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753100AbZCQOju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 10:39:50 -0400
From: Frans Pop <elendil@planet.nl>
To: john stultz <johnstul@us.ibm.com>
Subject: Re: [BUG,2.6.28,s390] Fails to boot in Hercules S/390 emulator
Date: Tue, 17 Mar 2009 15:39:45 +0100
User-Agent: KMail/1.9.9
Cc: linux-s390@vger.kernel.org, Roman Zippel <zippel@linux-m68k.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200903080230.10099.elendil@planet.nl> <200903120751.27821.elendil@planet.nl> <1237266901.7306.86.camel@localhost.localdomain>
In-Reply-To: <1237266901.7306.86.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200903171539.46695.elendil@planet.nl>
X-OriginalArrivalTime: 17 Mar 2009 14:39:47.0170 (UTC) FILETIME=[383D6C20:01C9A70E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 March 2009, john stultz wrote:
> > For me 2.6.28.7 is rock solid with the two reverts. I've attached my
> > kernel config and my Hercules config. I think the critical thing in
> > my config may be the "TIMERINT 500" setting for Hercules, which is
> > somewhat similar to your "goes away if HZ is anything except 250"
> > observation.
>
> I'll have to checkout that option.

Note that I later established that changing it did not have any effect.

> Does changing HZ value or disabling NO_HZ change anything for your
> situation as well? 

If I change that from 250 to 300 the system boots fine. And also if I
switch to NO_HZ.
