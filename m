Return-Path: <linux-kernel-owner+w=401wt.eu-S1030387AbXBZSIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030387AbXBZSIH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 13:08:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030391AbXBZSIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 13:08:07 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:5151 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030387AbXBZSIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 13:08:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LkaaRy0an4QCy6yW7szxyQFLBnh4HbNzf7ZyPH0euLOLsc3FDlUCfsfws59EU826nzwmcCMPM06ib7ShFT/4Rnc1BgG4v3QS3HxupF45gp40vrIt02rx/ZV1+Shai5F3K4vPKck4xcAq9zuCc1FVREjZZnamBrGdO2DnurSfvFI=
Message-ID: <da612e190702261007n6aabe651n3c8144dc89842f23@mail.gmail.com>
Date: Mon, 26 Feb 2007 19:07:54 +0100
From: "Mark Stier" <markstier@gmail.com>
To: "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: latencies due to disk writes
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <y0m649phzag.fsf@ton.toronto.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070226015439.97500@gmx.net>
	 <y0m649phzag.fsf@ton.toronto.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > I'm experiencing extreme lags during disk writes. [...]
>
> Wacky idea: "ionice -n 7 -c 2" down the pdflush/swapd kernel threads.

As I already wrote in my post, no disk IO scheduler cares for disk
writes. So even CFQ is only a disk *IN* scheduler...
