Return-Path: <linux-kernel-owner+w=401wt.eu-S1759596AbYAUOdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759596AbYAUOdv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 09:33:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753839AbYAUOdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 09:33:43 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:17884 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539AbYAUOdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 09:33:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=nkahbnZO+0Sp7TUcPR2LEiNzasTPU6jP4YeMLcKTOcbbPUzQ106rCBM+y1o8XgoIJ5ixBn8UPOwRcQA15z7FWwQ6Bm6x6vLddqzENEARkGxy1zGNwUugIY/8y0RJhPXPpRRjCdsVelB/vRwmjOfrYM1R3bwcXEDnk4YTx6LuLvw=
Message-ID: <4794AD3F.40309@gmail.com>
Date: Mon, 21 Jan 2008 23:33:35 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Georgi Chulkov <g.chulkov@jacobs-university.de>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Mark Lord <liml@rtr.ca>
Subject: Re: ATA device reset, shoud I be concerned?
References: <200801140019.20668.g.chulkov@jacobs-university.de>	<20080115025435.1e21b703.akpm@linux-foundation.org>	<20080115113552.75731bf8@lxorguk.ukuu.org.uk>	<4794501E.90306@gmail.com>	<20080121130256.2443d7c1@lxorguk.ukuu.org.uk>	<47949AA4.9090601@gmail.com> <20080121141425.45aa9c61@lxorguk.ukuu.org.uk> <4794ACAF.70505@gmail.com>
In-Reply-To: <4794ACAF.70505@gmail.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> IMHO, losing media error information is much better than locking up a
> machine hard.  We can start white listing known good controllers but I'm
> skeptical how much benefit it will bring.

Just a data point, even ICHs lock up after PHY event if the wrong TF
register is accessed.  I just don't think tempting with TF regs after
timeout is worth the cost.

-- 
tejun
