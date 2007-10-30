Return-Path: <linux-kernel-owner+w=401wt.eu-S1756046AbXJ3Rij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046AbXJ3Rij (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 13:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752239AbXJ3Ria
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 13:38:30 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:36931 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbXJ3Ri3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 13:38:29 -0400
Date: Tue, 30 Oct 2007 11:38:28 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: James.Bottomley@SteelEye.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [PATCH] drivers/scsi/dpt_i2o: Convert to generic boolean
Message-ID: <20071030173828.GB15111@parisc-linux.org>
References: <20071030104806.30936.13253.sendpatchset@thinktank.campus.ltu.se> <20071030145155.GL32359@parisc-linux.org> <47274781.3030606@student.ltu.se> <20071030151121.GM32359@parisc-linux.org> <47275FD0.4010400@student.ltu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47275FD0.4010400@student.ltu.se>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2007 at 05:46:08PM +0100, Richard Knutsson wrote:
> I just don't see the reason why expressing a boolean as an integer. Some 
> advantage?

This is C, not Java, or some other highly-typed language.
if (int) and if (ptr) are perfectly acceptable in C.

> (also helps us if someone does: 'if (var == true)', even thou we should 
> try to avoid them)

I have no idea what you mean.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
