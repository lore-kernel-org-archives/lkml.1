Return-Path: <linux-kernel-owner+w=401wt.eu-S1163457AbXD1S3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163457AbXD1S3a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 14:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163484AbXD1S3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 14:29:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163457AbXD1S32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 14:29:28 -0400
Date: Sat, 28 Apr 2007 14:28:55 -0400
From: Dave Jones <davej@redhat.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andi Kleen <ak@suse.de>, Simon Arlott <simon@arlott.org>,
       Dave Jones <davej@codemonkey.org.uk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
Subject: Re: [PATCH] [16/35] i386: Add an option for the VIA C7 which sets appropriate L1 cache
Message-ID: <20070428182855.GD20646@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jeff Garzik <jeff@garzik.org>, Andi Kleen <ak@suse.de>,
	Simon Arlott <simon@arlott.org>,
	Dave Jones <davej@codemonkey.org.uk>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
	patches@x86-64.org
References: <20070428752.712152000@suse.de> <20070428175240.E6704151CA@wotan.suse.de> <46338DBA.2050404@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46338DBA.2050404@garzik.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2007 at 02:08:58PM -0400, Jeff Garzik wrote:
 > Andi Kleen wrote:
 > > From: Simon Arlott <simon@arlott.org>
 > > 
 > > The VIA C7 is a 686 (with TSC) that supports MMX, SSE and SSE2, it also has
 > > a cache line length of 64 according to
 > > http://www.digit-life.com/articles2/cpu/rmma-via-c7.html.  This patch sets
 > > gcc to -march=686 and select s the correct cache shift.
 > > 
 > > Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
 > > Signed-off-by: Andi Kleen <ak@suse.de>
 > > Cc: Andi Kleen <ak@suse.de>
 > > Cc: Dave Jones <davej@codemonkey.org.uk>
 > > Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
 > > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
 > 
 > Has it been verified in the field that this CPU supports CMOV?

Yes. All their CPUs for some time now have done so.

	Dave

-- 
http://www.codemonkey.org.uk
