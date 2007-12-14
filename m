Return-Path: <linux-kernel-owner+w=401wt.eu-S932197AbXLNDNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197AbXLNDNA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 22:13:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755238AbXLNDMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 22:12:51 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58593 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754629AbXLNDMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 22:12:50 -0500
Date: Thu, 13 Dec 2007 22:12:46 -0500
From: Dave Jones <davej@redhat.com>
To: Paul Mackerras <paulus@samba.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, dwmw2@redhat.com
Subject: Re: Fix implicit declaration in via-pmu.c
Message-ID: <20071214031246.GB14000@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Paul Mackerras <paulus@samba.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>, dwmw2@redhat.com
References: <20071213215911.GA8591@redhat.com> <18273.61952.774601.392188@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18273.61952.774601.392188@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2007 at 02:01:20PM +1100, Paul Mackerras wrote:
 > Dave Jones writes:
 > 
 > > drivers/macintosh/via-pmu.c: In function 'register_pmu_pm_ops':
 > > drivers/macintosh/via-pmu.c:2481: error: implicit declaration of function 'pm_set_ops'
 > 
 > What tree is this against?  I don't see any occurrences of pmu_pm_ops
 > in either 2.6.23 or Linus' current tree, or in my published
 > powerpc.git tree.

*grmbl*, it's on top of a bunch of other ppc suspend bits.
I blame dwmw2.

You can safely drop this.   Thanks.

	Dave

-- 
http://www.codemonkey.org.uk
