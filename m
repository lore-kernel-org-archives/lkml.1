Return-Path: <linux-kernel-owner+w=401wt.eu-S1754897AbXE3Nxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbXE3Nxh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 09:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbXE3Nx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 09:53:28 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33841 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974AbXE3Nx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 09:53:27 -0400
Message-ID: <465D81D3.7040609@garzik.org>
Date: Wed, 30 May 2007 09:53:23 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] defxx: Fix the handling of ioremap() failures
References: <Pine.LNX.4.64N.0705291508300.14456@blysk.ds.pg.gda.pl>
In-Reply-To: <Pine.LNX.4.64N.0705291508300.14456@blysk.ds.pg.gda.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej W. Rozycki wrote:
>  If ioremap_nocache() is unfortunate enough to fail, the error code is not 
> set correctly leading to a false success from dfx_register().  This change 
> fixes the problem.
> 
> Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>

applied


