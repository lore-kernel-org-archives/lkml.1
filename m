Return-Path: <linux-kernel-owner+w=401wt.eu-S1751468AbXA2OEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468AbXA2OEj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 09:04:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbXA2OEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 09:04:39 -0500
Received: from cavan.codon.org.uk ([217.147.92.49]:32862 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbXA2OEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 09:04:38 -0500
Date: Mon, 29 Jan 2007 14:04:08 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: roucaries bastien <roucaries.bastien@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Larry Finger <larry.finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>,
       bcm43xx devel <Bcm43xx-dev@lists.berlios.de>
Message-ID: <20070129140408.GA19379@srcf.ucam.org>
References: <45B92488.6090908@lwfinger.net> <45B92536.2080909@lwfinger.net> <195c7a900701251530m409878a8id301c7cada76f342@mail.gmail.com> <45BA246B.6030505@lwfinger.net> <20070129115842.GA4928@ucw.cz> <195c7a900701290455o3ff9fc15k305637f8ced24caf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <195c7a900701290455o3ff9fc15k305637f8ced24caf@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: Bcm43xx oops after suspend to disk
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 29, 2007 at 01:55:41PM +0100, roucaries bastien wrote:
> -       return 0;
> +       return bcm43xx_init_one(pdev, NULL);
> }

While this may well work (it's basically equivalent to unloading and 
reloading the module), it's not a long-term fix - userspace is going to 
notice the interface vanishing and reappearing. Larry, I guess you just 
mean this as a test patch?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
