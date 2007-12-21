Return-Path: <linux-kernel-owner+w=401wt.eu-S1763014AbXLUDCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763014AbXLUDCE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 22:02:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754310AbXLUDBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 22:01:54 -0500
Received: from there.is.no.cabal.ca ([134.117.69.58]:60405 "EHLO
	fattire.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045AbXLUDBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 22:01:53 -0500
Date: Thu, 20 Dec 2007 22:01:52 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Kyle McMartin <kmcmartin@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.24-rc6
Message-ID: <20071221030152.GC8535@fattire.cabal.ca>
References: <alpine.LFD.0.9999.0712201731010.21557@woody.linux-foundation.org> <20071221024805.GB8535@fattire.cabal.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071221024805.GB8535@fattire.cabal.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2007 at 09:48:05PM -0500, Kyle McMartin wrote:
> 1 out of 3 hunks FAILED -- saving rejects to file
> drivers/video/mbx/reg_bits.h.rej
> error: Bad exit status from /var/tmp/rpm-tmp.22316 (%prep)
> 

I think I see the problem, it's lack of context in the diff,

commit ba282daa919f89c871780f344a71e5403a70b634
Author: Raphael Assenat <raph@8d.com>
Date:   Tue Oct 16 01:28:40 2007 -0700

seems to duplicate the DINTRS & DINTRE defines for no obvious reason,
confusing the hell out of patch.

regards,
	Kyle
