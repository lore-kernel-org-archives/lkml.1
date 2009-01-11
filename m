Return-Path: <linux-kernel-owner+w=401wt.eu-S1756900AbZAKOKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900AbZAKOKe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 09:10:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753920AbZAKOKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 09:10:20 -0500
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:61995 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754817AbZAKOKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 09:10:19 -0500
Message-ID: <4969FD64.8040408@gentoo.org>
Date: Sun, 11 Jan 2009 14:08:36 +0000
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090101)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jeff Chua <jeff.chua.linux@gmail.com>, Phil Dibowitz <phil@ipom.com>
Subject: Re: [Bug #12422] 2.6.28-git can't resume from str
References: <XU-8icArWLM.A.UpG.8GfaJB@chimera> <oWTznAnH9BI.A.qDH.EHfaJB@chimera>
In-Reply-To: <oWTznAnH9BI.A.qDH.EHfaJB@chimera>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.0 c=1 a=9WQ-84sW6mEA:10 a=afleWMBT7sQA:10 a=VwQbUJbxAAAA:8 a=gu6fZOg2AAAA:8 a=TRRfj7fYkN99VFOmH-kA:9 a=kW7FWYmDAqxD5eykoNNHaMxRZxkA:4 a=QJAqVYndk0IA:10 a=M3WBCiC-_X4A:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12422
> Subject		: 2.6.28-git can't resume from str
> Submitter	: Jeff Chua <jeff.chua.linux@gmail.com>
> Date		: 2009-01-10 1:39 (2 days old)
> References	: http://marc.info/?l=linux-kernel&m=123155157909282&w=4

The bisection looks invalid. It is unlikely to be this commit at fault. 
Jeff, do you even have that camera?

It is also easy to revert that commit by hand. Just delete the 
unusual_devs entry for it.

Daniel

