Return-Path: <linux-kernel-owner+w=401wt.eu-S2992734AbXCBXTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992734AbXCBXTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 18:19:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992731AbXCBXTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 18:19:16 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:54613 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992728AbXCBXTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 18:19:15 -0500
Message-ID: <45E8B0F0.1090407@garzik.org>
Date: Fri, 02 Mar 2007 18:19:12 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_qdi: Fix initialisation
References: <20070302145635.1fc6fac7@lxorguk.ukuu.org.uk>
In-Reply-To: <20070302145635.1fc6fac7@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> The QDI init code contains some bugs which mean it only works if you have
> a test setup that causes both a successful and failed probe. Fix this
> 
> Found by Philip Guo
> 
> (Who found it working on code analysis tools not running VLB IDE
> controllers)
> 
> Signed-off-by: Alan Cox <alan@redhat.com>diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc2/drivers/ata/pata_qdi.c linux-2.6.21-rc2/drivers/ata/pata_qdi.c

applied, though it appears your patch-sending script munched a few newlines


