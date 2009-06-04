Return-Path: <linux-kernel-owner+w=401wt.eu-S1754445AbZFDUdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445AbZFDUdb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 16:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbZFDUdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 16:33:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40174 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255AbZFDUdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 16:33:22 -0400
Date: Thu, 4 Jun 2009 16:33:13 -0400
From: Dave Jones <davej@redhat.com>
To: "Michael S. Zick" <lkml@morethan.org>
Cc: Harald Welte <HaraldWelte@viatech.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.30-rc8 [also: VIA Support]
Message-ID: <20090604203313.GA19286@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Michael S. Zick" <lkml@morethan.org>,
	Harald Welte <HaraldWelte@viatech.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Duane Griffin <duaneg@dghda.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <200906041121.30845.lkml@morethan.org> <20090604174059.GB9823@prithivi.gnumonks.org> <200906041312.45847.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906041312.45847.lkml@morethan.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 01:12:43PM -0500, Michael S. Zick wrote:
 > On Thu June 4 2009, Harald Welte wrote:
 > > On Thu, Jun 04, 2009 at 11:21:28AM -0500, Michael S. Zick wrote:
 > > 
 > > > That is one of my pending questions - -
 > > > (It is included as a comment at the appropriate point in my patchset.)
 > > > 
 > > > The VIA processors have MCR's not MTRR's - -
 > > 
 > > AFAIK, that was true for processors like the Winhcip / C6, i.e. earlier than
 > > the C3.  The C3, C7 and later support 8 intel-style MTRR's.
 > > 
 > 
 > Super!  A specific breakage!
 > 
 > The c7 setup code is re-using the c6 setup code (MCR's) - -
 > Will "if 0" out the appropriate parts and arrange for the MTRR setup.

It's not touching the MCRs.   C7's are family 6. The MCR code is only
called for family 5. (Winchips)   Look at the switch statement
in init_centaur()

	Dave

