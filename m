Return-Path: <linux-kernel-owner+w=401wt.eu-S1754597AbYCORYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbYCORYj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 13:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754280AbYCORYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 13:24:30 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:33687 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754244AbYCORY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 13:24:29 -0400
Date: Sat, 15 Mar 2008 18:24:18 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Ingo Oeser <ingo.oeser@rameria.de>
cc: john stultz <johnstul@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 4/5]  ntp.c code flow clenaups  (from Ingo)
In-Reply-To: <200803151339.21101.ingo.oeser@rameria.de>
Message-ID: <Pine.LNX.4.64.0803151823380.1791@scrub.home>
References: <1205553852.6122.76.camel@localhost.localdomain>
 <1205554210.6122.85.camel@localhost.localdomain> <1205554366.6122.88.camel@localhost.localdomain>
 <200803151339.21101.ingo.oeser@rameria.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, 15 Mar 2008, Ingo Oeser wrote:

> I don't understand, why the goto is required here. 
> 
> If you move these two cases in front of case "TIME_OK" and
> omit the break, you can remove the goto and the label "start_timer".
> Don't forget the /* fall through */ comment then.

Nice catch, I'll do this in the original patch.

bye, Roman
