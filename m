Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab0BQS66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 13:58:58 -0500
Received: from mail.windriver.com ([147.11.1.11]:37566 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab0BQS65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 13:58:57 -0500
Message-ID: <4B7C3C56.8040801@windriver.com>
Date: Wed, 17 Feb 2010 12:58:30 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       mingo@elte.hu
Subject: Re: [PATCH 15/28] kgdb,docs: Update the kgdb docs to include kdb
References: <1266014143-29444-1-git-send-email-jason.wessel@windriver.com> <1266014143-29444-16-git-send-email-jason.wessel@windriver.com> <4B7700B0.1030402@xenotime.net>
In-Reply-To: <4B7700B0.1030402@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Feb 2010 18:58:30.0839 (UTC) FILETIME=[32471470:01CAB003]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On 02/12/10 14:35, Jason Wessel wrote:
>> +	kgdbwait	[KGDB] Stop kernel execution and enter the
>> +			kernel debugger at the earliest opportunity if
>> +			kgdb was configured on as a boot argument.
> 
> What does "kgdb was configured on as a boot argument" mean?
> 

Changed to:

-- 
	kgdbwait	[KGDB] Stop kernel execution and enter the
			kernel debugger at the earliest opportunity.
--


We'll assume someone actually configured the kernel debugger with
ekgdboc, kgdboc, or kgdbdbgp.  The previous text was attempting to
indicate that kgdbwait only does something when you also configure a
kgdb I/O driver.

Where it stops varies on how early the I/O driver and architecture
trap processing is available.

Jason.



