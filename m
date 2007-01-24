Return-Path: <linux-kernel-owner+w=401wt.eu-S965474AbXAXBzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965474AbXAXBzI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 20:55:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965100AbXAXBzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 20:55:08 -0500
Received: from wr-out-0506.google.com ([64.233.184.239]:4699 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965474AbXAXBzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 20:55:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=dvrIijN/c5F224IVlAi6H81c6ga99CbxqJlS5oddo6QML8LKBvS4BYKJK3FU/yngPkDxce3LsHpbUg1UEvHNRaKG+jTDKxLHRh5oUC8gEX1oNanz7JtTR2pPbCmcAup4uMlZHJ/CGGuggr37h7U9HIDVFeu2KMdHEVMYSq8IAlA=
Message-ID: <45B6BC6D.8070301@gmail.com>
Date: Wed, 24 Jan 2007 10:54:53 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Pablo Sebastian Greco <lkml@fliagreco.com.ar>
CC: linux-kernel@vger.kernel.org
Subject: Re: SATA problems
References: <459A674B.3060304@fliagreco.com.ar> <459B9F91.9070908@gmail.com> <459BC703.9000207@fliagreco.com.ar> <459C8A5E.5010206@gmail.com> <459CFE7B.6090306@fliagreco.com.ar> <459DC2EE.1090307@fliagreco.com.ar> <45A1AB3F.1080408@gmail.com> <45A2376D.5060905@fliagreco.com.ar> <45A41E0E.9050608@fliagreco.com.ar> <45A4477E.6050703@gmail.com> <45B649BF.5030705@fliagreco.com.ar>
In-Reply-To: <45B649BF.5030705@fliagreco.com.ar>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pablo Sebastian Greco wrote:
> Well, it took me a few days,  but I think I'm ready to report back. One
> of the drives was failing, and it stopped after rewiring power supply so
> the last problem seems to be corrected.
> OTOH, your blacklist seems to be needed too, now I'm running FC6
> distribution kernel 2.6.19-1.2895.fc6 (2.6.19.2 + some patches by
> fedora) and setting
> echo 1 >/sys/block/sdX/device/queue_depth
> on all the SAMSUNG drives (sdb, sdc and sdd)
> The second I type
> echo 31 >/sys/block/sdX/device/queue_depth
> on any of the drives I get these messages
> 
> Jan 23 12:36:30 squid kernel: BUG: warning: (ap->ops->error_handler &&
> ata_tag_valid(ap->active_tag)) at
> drivers/ata/libata-core.c:4602/ata_qc_issue() (Not ta
> inted)

This is kernel bug that needs fixing.  I'll investigate.

-- 
tejun
