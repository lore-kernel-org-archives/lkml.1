Return-Path: <linux-kernel-owner+w=401wt.eu-S1756588AbYLJQx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588AbYLJQx0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 11:53:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755356AbYLJQxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 11:53:17 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:55227 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755346AbYLJQxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 11:53:17 -0500
Date: Wed, 10 Dec 2008 16:52:52 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Frans Pop <elendil@planet.nl>, Ingo Molnar <mingo@elte.hu>,
       lenb@kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Greg KH <greg@kroah.com>, jbarnes@virtuousgeek.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: "APIC error on CPU1: 00(40)" during resume (was: Regression from 2.6.26: Hibernation (possibly suspend) broken on Toshiba R500)
Message-ID: <20081210165252.GA13041@srcf.ucam.org>
References: <200812020320.31876.rjw@sisk.pl> <200812101506.45691.elendil@planet.nl> <alpine.LFD.2.00.0812100740390.3340@localhost.localdomain> <200812101705.18899.elendil@planet.nl> <alpine.LFD.2.00.0812100819570.3340@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0812100819570.3340@localhost.localdomain>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 08:26:37AM -0800, Linus Torvalds wrote:

> So it looks like we don't reprogram the APIC -at-all- on secondary CPU's.
> 
> What am I missing?

We unplug all CPUs except the boot one at suspend time. Does the APIC 
get reprogrammed when they're replugged on resume?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
