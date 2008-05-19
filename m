Return-Path: <linux-kernel-owner+w=401wt.eu-S1756230AbYESHKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230AbYESHKR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 03:10:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753599AbYESHKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 03:10:04 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:46160 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282AbYESHKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 03:10:03 -0400
Message-ID: <483127B9.3010205@linux.vnet.ibm.com>
Date: Mon, 19 May 2008 12:39:45 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080505)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nadia.Derbey@bull.net, bunk@kernel.org
Subject: Re: [Bug #10641] [BUG] 2.6.26-rc1-git4 - task blocked on powerpc
 for more than 120 seconds
References: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik> <7wuznNhcUqC.A.FEB.MtBMIB@albercik>
In-Reply-To: <7wuznNhcUqC.A.FEB.MtBMIB@albercik>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10641
> Subject		: [BUG] 2.6.26-rc1-git4 - task blocked on powerpc for more than 120 seconds
> Submitter	: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> Date		: 2008-05-07 13:34 (12 days old)
> References	: http://marc.info/?l=linux-kernel&amp;m=121016673607188&amp;w=2
> 

This bug seems to be because of the LTP version used, as pointed by Nadia. Using the
latest LTP (2008-04-30), does not produces the calltraces mentioned in the bug. 


-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
