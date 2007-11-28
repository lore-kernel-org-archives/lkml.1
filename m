Return-Path: <linux-kernel-owner+w=401wt.eu-S1760997AbXK1T1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760997AbXK1T1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 14:27:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755331AbXK1T1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 14:27:09 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:51443 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815AbXK1T1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 14:27:07 -0500
Date: Wed, 28 Nov 2007 12:27:03 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, akpm@osdl.org,
       linux-kernel@vger.kernel.org, "Patro, Sumant" <Sumant.Patro@lsi.com>,
       "Kolli, Neela" <Neela.Kolli@lsi.com>
Subject: Re: [PATCH 1/1] scsi: megaraid_sas - Fix random failure of DCDB cmds with sense info
Message-ID: <20071128192703.GA2584@parisc-linux.org>
References: <20071127153252.GC3230@parisc-linux.org> <9738BCBE884FDB42801FAD8A7769C26501D33B5B@NAMAIL1.ad.lsil.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9738BCBE884FDB42801FAD8A7769C26501D33B5B@NAMAIL1.ad.lsil.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2007 at 12:08:37PM -0700, Yang, Bo wrote:
> Matthew,
> 
> Yes, as I mentioned, our applications are built in 32-bit environment
> (except for ia64).
> We may see a different behavior if we build it in 64-bit for x86-64. 

Then this patch isn't acceptable.  You need to find a way which works
for both 32-bit and 64-bit applications.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
