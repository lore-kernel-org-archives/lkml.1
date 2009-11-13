Return-Path: <linux-kernel-owner+w=401wt.eu-S932427AbZKMVNN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932427AbZKMVNN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 16:13:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932325AbZKMVNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 16:13:09 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:37940 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932315AbZKMVNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 16:13:08 -0500
Date: Fri, 13 Nov 2009 21:13:06 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>, bcm43xx-dev@lists.berlios.de,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 64-bit DMA problems with BCM4312 using b43
Message-ID: <20091113211306.GA6600@srcf.ucam.org>
References: <4AFD958E.1000303@lwfinger.net> <20091113201112.GA5540@srcf.ucam.org> <200911132144.24110.mb@bu3sch.de> <4AFDCA0E.4080007@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AFDCA0E.4080007@lwfinger.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13, 2009 at 03:05:18PM -0600, Larry Finger wrote:

> I'm in the process of creating a patch to set the latency to 200 usec. The
> default is 2000. On my fast prosessors, it should not be anything nearly that
> slow. If we determine this to be the problem, then we can try tuning.

The latency is the amount of time it takes to get out of deep C states 
and into C0. That's a function of the processor design rather than the 
frequency.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
