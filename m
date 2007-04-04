Return-Path: <linux-kernel-owner+w=401wt.eu-S1753750AbXDDGhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750AbXDDGhh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 02:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753753AbXDDGhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 02:37:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35677 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753748AbXDDGhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 02:37:36 -0400
Date: Wed, 4 Apr 2007 02:37:01 -0400
From: Dave Jones <davej@redhat.com>
To: Bernhard Kaindl <bk@suse.de>
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Andi Kleen <ak@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 0/4] Fix MTRR suspend support for specific machines (some AMD64, maybe others also)
Message-ID: <20070404063701.GA5539@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Bernhard Kaindl <bk@suse.de>, linux-kernel@vger.kernel.org,
	Pavel Machek <pavel@ucw.cz>, Andi Kleen <ak@suse.de>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Jan Beulich <jbeulich@novell.com>
References: <Pine.LNX.4.64.0703211730140.2519@jbgna.fhfr.qr> <200703272213.51947.ak@suse.de> <Pine.LNX.4.64.0703281155490.17746@jbgna.fhfr.qr> <200703291525.59116.ak@suse.de> <Pine.LNX.4.64.0703301702320.21293@jbgna.fhfr.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703301702320.21293@jbgna.fhfr.qr>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2007 at 03:55:32PM +0200, Bernhard Kaindl wrote:

 > PS: I attached a program which uses msr.ko (CONFIG_X86_MSR) from
 >  Processor type and features
 >      -> [M/*] /dev/cpu/*/msr - Model-specific register support
 > to dump the contents of the fixed-range MTTRs to stdout.
 > 
 > On a two-CPU system, the output format looks like this:
 > 
 > MSR 0x250: 1e1e1e1e1e1e1e1e | 0606060606060606 |
 > MSR 0x258: 1e1e1e1e1e1e1e1e | 0606060606060606 |
 > MSR 0x259: 0000000000000000 | 0000000000000000 |
 > MSR 0x268: 1515151515151515 | 0505050505050505 |
 > MSR 0x269: 1515151515151515 | 0505050505050505 |
 > MSR 0x26a: 0000000000000000 | 0000000000000000 |
 > MSR 0x26b: 0000000000000000 | 0000000000000000 |
 > MSR 0x26c: 1515151500000000 | 0505050500000000 |
 > MSR 0x26d: 1515151515151515 | 0505050505050505 |
 > MSR 0x26e: 1515151515151515 | 0505050505050505 |
 > MSR 0x26f: 1515151515151515 | 0505050505050505 |

FWIW, x86info --mtrr would have done this for you :)

 > To have a sane MTRR setup the MTRRs of the CPUs should always
 > match, but this has so far not lead to problems, it seems. However,
 > Intel and AMD manuals tell us to keep MTRRs in sync for good reasons.

Indeed.  From a quick lookover, I don't see anything obviously
wrong in your patches, though Jan and Andi probably remember more
gory details about that code than I'll admit to.

	Dave

-- 
http://www.codemonkey.org.uk
