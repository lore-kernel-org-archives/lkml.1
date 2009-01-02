Return-Path: <linux-kernel-owner+w=401wt.eu-S1756914AbZABCho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914AbZABCho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 21:37:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755570AbZABChe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 21:37:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:49460 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755483AbZABChd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 21:37:33 -0500
Message-ID: <495D7DC9.8070101@kernel.org>
Date: Fri, 02 Jan 2009 11:36:57 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata hibernation fixes
References: <20081104062734.GA4420@havoc.gtf.org>
In-Reply-To: <20081104062734.GA4420@havoc.gtf.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 02 Jan 2009 02:37:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> This adds code at a late stage (heading towards -rc4), but does
> eliminate a particular spin-up overcycling behavior associated with
> hibernation.
> 
> Rafael's extended description below...  Separated to make it easier to
> pull-or-not, separate from the other libata fixes.  There shouldn't be
> any merge trouble between the two.
> 
> SATA: Blacklist systems that spin off disks during ACPI power off

Jeff, I think this should be merged into 2.6.29 unless Linus still
objects.  Linus, as discussed in this thread, this is workaround for a
hardware / firmware problem and vanilla windows also suffers the
problem, so as ugly as it is, we need this to prevent double spin down
on the machine.

Thanks and happy new year.

-- 
tejun
