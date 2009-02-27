Return-Path: <linux-kernel-owner+w=401wt.eu-S1759011AbZB0HMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759011AbZB0HMA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 02:12:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbZB0HLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 02:11:51 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:35457 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580AbZB0HLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 02:11:49 -0500
Date: Fri, 27 Feb 2009 16:08:05 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: dwmw2 <dwmw2@infradead.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input <linux-input@vger.kernel.org>,
       linux-sh <linux-sh@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       MTD <linux-mtd@lists.infradead.org>
Subject: Re: [PATCH] mtd: sh: maple: Support the Dreamcast visual memory unit as a flash mapping
Message-ID: <20090227070805.GD28802@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <adrian@newgolddream.dyndns.info>,
	dwmw2 <dwmw2@infradead.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-input <linux-input@vger.kernel.org>,
	linux-sh <linux-sh@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	MTD <linux-mtd@lists.infradead.org>
References: <1234641948.6609.13.camel@localhost.localdomain> <1234642605.6609.17.camel@localhost.localdomain> <1234643202.6609.25.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234643202.6609.25.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 14, 2009 at 08:26:42PM +0000, Adrian McMenamin wrote:
> This patch adds support for the Sega Dreamcast visual memory unit as a
> flash mapping. It requires changes in the maple bus driver (posted
> separately) to support block reads and writes.
> 
> The VMU is a 'smart' flash device, with a built-in 8-bit controller -
> for instance there is an erase before a write but it is hidden from the
> user. But the device's overall behaviour means it works well with the
> mtd layer and it is appropriate to add it as an mtd mapping.
> 
> Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>

If someone from the MTD side wants to Ack this, I can fold it in to my
tree on top of the maple patch that it depends on, which I already have
queued.
