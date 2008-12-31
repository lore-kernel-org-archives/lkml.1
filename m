Return-Path: <linux-kernel-owner+w=401wt.eu-S1755859AbYLaD7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859AbYLaD7c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 22:59:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268AbYLaD7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 22:59:24 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:44387 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165AbYLaD7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 22:59:24 -0500
Message-ID: <495AEE05.1080005@oracle.com>
Date: Tue, 30 Dec 2008 19:59:01 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>, drzeus-mmc@drzeus.cx
Subject: Re: mmotm 2008-12-30-16-05 uploaded (mmc)
References: <200812310006.mBV060iV029753@imap1.linux-foundation.org>
In-Reply-To: <200812310006.mBV060iV029753@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.495AEE08.018A:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2008-12-30-16-05 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://git.zen-sources.org/zen/mmotm.git
> 
> It contains the following patches against 2.6.28:


mmotm-2008-1230-1605/drivers/mmc/host/ricoh_mmc.c:235: error: variable 'ricoh_mmc_pm_opts' has initializer but incomplete type
mmotm-2008-1230-1605/drivers/mmc/host/ricoh_mmc.c:236: error: unknown field 'suspend_noirq' specified in initializer
mmotm-2008-1230-1605/drivers/mmc/host/ricoh_mmc.c:236: warning: excess elements in struct initializer
mmotm-2008-1230-1605/drivers/mmc/host/ricoh_mmc.c:236: warning: (near initialization for 'ricoh_mmc_pm_opts')
mmotm-2008-1230-1605/drivers/mmc/host/ricoh_mmc.c:237: error: unknown field 'resume_noirq' specified in initializer
mmotm-2008-1230-1605/drivers/mmc/host/ricoh_mmc.c:237: warning: excess elements in struct initializer
mmotm-2008-1230-1605/drivers/mmc/host/ricoh_mmc.c:237: warning: (near initialization for 'ricoh_mmc_pm_opts')


struct dev_pm_ops seems not to exist AFAICT.


-- 
~Randy
