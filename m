Return-Path: <linux-kernel-owner+w=401wt.eu-S934013AbXHPQ2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934013AbXHPQ2r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 12:28:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765442AbXHPQ2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 12:28:32 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:41816 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765534AbXHPQ2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 12:28:30 -0400
Date: Fri, 17 Aug 2007 01:27:24 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Andy Whitcroft <apw@shadowen.org>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@osdl.org>, linuxsh-dev@lists.sourceforge.net
Subject: Re: [PATCH 3/6] sh: remove extraneous ; on scif_sercon_putc wait loop
Message-ID: <20070816162724.GA15562@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org,
	Randy Dunlap <rdunlap@xenotime.net>, Andrew Morton <akpm@osdl.org>,
	linuxsh-dev@lists.sourceforge.net
References: <exportbomb.1187270320@pinky> <1495a7af981296bd422ef293e96ad167@pinky>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1495a7af981296bd422ef293e96ad167@pinky>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2007 at 02:18:56PM +0100, Andy Whitcroft wrote:
> It seems we have gained an extraneous trailing ';' on one of the
> wait loops in scif_sercon_putc().  Although this is completely
> benign as the apparent payload is also the empty statement, it
> invites error in the future.  Clean it up now.
> 
> Signed-off-by: Andy Whitcroft <apw@shadowen.org>

Applied, thanks.
