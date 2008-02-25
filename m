Return-Path: <linux-kernel-owner+w=401wt.eu-S1759427AbYBYVEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759427AbYBYVEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 16:04:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750992AbYBYVEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 16:04:15 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:55949 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926AbYBYVEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 16:04:14 -0500
Message-ID: <47C32D48.7060909@garzik.org>
Date: Mon, 25 Feb 2008 16:04:08 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>, Pavel Machek <pavel@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-ide@vger.kernel.org
Subject: Re: new regression in 2.6.25-rc3: can't resume from suspend to ram,
 ata1 errors
References: <8f53421d0802251257o75d2975dldcfb99a2dc5e3539@mail.gmail.com>
In-Reply-To: <8f53421d0802251257o75d2975dldcfb99a2dc5e3539@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael S. Tsirkin wrote:
> git bisect points at this commit:
> commit 559bbe6cbd0d8c68d40076a5f7dc98e3bf5864b2.
> power_state: get rid of write-only variable in SATA


Hello Pavel --

It looks like this not a write-only variable after all...

	Jeff


