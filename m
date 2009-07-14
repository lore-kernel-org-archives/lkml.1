Return-Path: <linux-kernel-owner+w=401wt.eu-S1755176AbZGNTJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbZGNTJg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 15:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753665AbZGNTJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 15:09:35 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:57088 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753373AbZGNTJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 15:09:35 -0400
Message-ID: <4A5CD77C.6070701@garzik.org>
Date: Tue, 14 Jul 2009 15:07:40 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Sonic Zhang <sonic.zhang@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH] libata: pata_bf54x: handle portmuxing of pins through
 GPIO PORTs
References: <1247593187-26570-1-git-send-email-vapier@gentoo.org>
In-Reply-To: <1247593187-26570-1-git-send-email-vapier@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> From: Sonic Zhang <sonic.zhang@analog.com>
> 
> By default, the PATA pins are routed to the async address lines in which
> case, no peripheral muxing needs to be done.  However, if the pins get
> routed through the GPIO PORTs pins, we need to make sure to request them
> so that the muxing is properly set up.
> 
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
> Andrew: could you pick this up ?  it was posted over a month ago to the
> Linux/IDE list w/no feedback.

Although it is disappointing that your patch was missed -- our apologies 
-- I don't think the best response was to elide linux-ide and the libata 
maintainer, in favor of a higher noise list.  :)

I have the patch queued, now.

	Jeff



