Return-Path: <linux-kernel-owner+w=401wt.eu-S1763939AbXESLsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763939AbXESLsv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 07:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763596AbXESLsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 07:48:38 -0400
Received: from mail.syneticon.net ([213.239.212.131]:48996 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763842AbXESLsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 07:48:37 -0400
Message-ID: <464EE3E9.80708@wpkg.org>
Date: Sat, 19 May 2007 13:47:53 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061110 Mandriva/1.5.0.8-1mdv2007.1 (2007.1) Thunderbird/1.5.0.8 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sata_mv: new exception handling (hotplug, NCQ framework)
References: <20070519054201.GA32686@havoc.gtf.org>
In-Reply-To: <20070519054201.GA32686@havoc.gtf.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik schrieb:
> Below is a refresh of my on-going effort to convert sata_mv to the new
> exception handling framework.  sata_mv is one of the last hold-outs, and
> its old-EH implementation blocks new features like hotplug and NCQ.
> 
> It works for me on the one 50xx and one 60xx card I tested it on, but
> other testers reported regressions, which is why it is not yet upstream.

Hi,

If I'm correct, this patch won't make to 2.6.22, and the first possible 
inclusion would be 2.6.23?

Could you summarize what other regressions were reported? I can't find 
much information about sata_mv regressiobs on linux-ide list (at least 
when looking at the subjects: lots of patches from you, and two reports 
from me).


-- 
Tomasz Chmielewski
