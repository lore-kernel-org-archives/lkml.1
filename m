Return-Path: <linux-kernel-owner+w=401wt.eu-S1756058AbYDDGQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058AbYDDGQM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 02:16:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752031AbYDDGP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 02:15:58 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:60243 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026AbYDDGP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 02:15:57 -0400
Date: Fri, 4 Apr 2008 09:15:56 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: regression: am-utils stopped working in 2.6.25-rc*
In-Reply-To: <pdYe6zNQVl.A.Dd.HEW9HB@albercik>
Message-ID: <Pine.SOC.4.64.0804040914080.8007@math.ut.ee>
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik> <pdYe6zNQVl.A.Dd.HEW9HB@albercik>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The following report is on the current list of known regressions
> from 2.6.24.  Please verify if the issue is still present in the
> mainline.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10349
> Subject		: regression: am-utils stopped working in 2.6.25-rc*
> Submitter	: Meelis Roos <mroos@linux.ee>
> Date		: 2008-03-28 15:20 (7 days old)
> References	: http://lkml.org/lkml/2008/3/28/174

Still present, active discussion in bugzilla. At least partly am-utils 
problem (actually there are 2 of them, one am-utils mount structure 
version problem, another NFS locking problem that was also uncoveredy by 
stricter checking in 2.6.25).

-- 
Meelis Roos (mroos@linux.ee)
