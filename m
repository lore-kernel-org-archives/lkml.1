Return-Path: <linux-kernel-owner+w=401wt.eu-S1758769AbZKYMJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758769AbZKYMJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 07:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758688AbZKYMJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 07:09:18 -0500
Received: from mail.sv1.nifty.com ([220.209.183.60]:30409 "EHLO
	defg301p.nifty.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758674AbZKYMJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 07:09:17 -0500
X-Greylist: delayed 450 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Nov 2009 07:09:17 EST
DomainKey-Signature: a=rsa-sha1; s=2007jul; d=nifty.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:x-priority:
	x-msmail-priority:priority:x-mailer:references;
	b=A2YplVgqH89bE7mi5xs/a1pulERrHPAAzO5EbEgNnkXA0leLm1dG30DRuAGxSwJSY
	jIjmwX6/w3OWPTAwkKY1g==
X-Nifty-SrcIP: [172.22.128.192]
Message-ID: <10200001.47511259150210534.komurojun-mbn@nifty.com>
Date: Wed, 25 Nov 2009 20:56:50 +0900 (JST)
From: Komuro <komurojun-mbn@nifty.com>
To: Peter Stuge <peter@stuge.se>
Subject: Re: Re: ioports 0x100-0x3af and iomem 0xd000-0xdffff, 0xa0000000-0xa0ffffff -- safe to use on x86 for pcmcia?
Cc: x86@kernel.org, Komuro <komurojun-mbn@nifty.com>,
       linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <20091124231653.30084.qmail@stuge.se>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: @nifty Webmail 2.0
References: <20091124231653.30084.qmail@stuge.se>
 <20091124213723.GA22689@comet.dominikbrodowski.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

>c0000-fffff is option ROM and BIOS land. Maybe every BIOS out there
>is being a good boy/girl and actually adds entries to e820 or similar
>but I would kindof like to stay away from the region anyway.
>
>0xa0000000 is 2.5GB, so it's doomed on systems with >=2.5GB RAM. :(
>
>
>//Peter

(1)
The i82365(ISA-pcmcia controller) and some older card-bus controller
need the c000-fffff area to access the CIS instead of high memory area
(1MB above).

(2) 
Most of the PC that need the PCMCIA card is not so new.
and have less than 2.5GB.

Best Regards
Komuro

