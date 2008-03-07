Return-Path: <linux-kernel-owner+w=401wt.eu-S1764805AbYCGTO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764805AbYCGTO1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 14:14:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758395AbYCGTOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 14:14:10 -0500
Received: from jbanks.dsl.xmission.com ([204.228.152.159]:37655 "EHLO
	mail.bakbone.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755595AbYCGTOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 14:14:09 -0500
From: Justin Banks <justinb@bakbone.com>
Date: Fri, 7 Mar 2008 12:13:43 -0700
To: Bill Davidsen <davidsen@tmr.com>
Cc: Justin Banks <justinb@bakbone.com>,
       "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>,
       linux-kernel@vger.kernel.org
Subject: Re: FW: Linux question
Message-ID: <20080307191343.GB4703@bleen.domain.actdsltmp>
References: <DEE40752C8AF224BB890E455C7B8E0FE042B84B112@G6W0268.americas.hpqcorp.net> <20080306203841.GA4282@bleen.domain.actdsltmp> <47D18CE1.7050206@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D18CE1.7050206@tmr.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Davidsen wrote
> Justin Banks wrote:
> > Miller, Mike (OS Dev) wrote
> >> Is there a way in to limit the kernel to seeing only the cores on a
> >> single processor and ignore all other processor cores (eg. leave
> >> them in HALT)?
> > 
> > Can't you just echo 0 into /sys/devices/system/cpu/cpuN/online where the
> > /sys/devices/system/cpu/cpuN/topology/physical_package_id isn't the one
> > you want to keep online?
> > 
> Here's an interesting question, why isn't there an "online" file for 
> each CPU?

I've noticed that as well, and I'm not sure. IIRC, on some systems I've
seen there's an online file for every CPU, but on my laptop (2.6.22
Intel Mac) there isn't one for cpu0, just as in your example.

-justinb

-- 
Justin Banks
BakBone Software
justinb@bakbone.com
