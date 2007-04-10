Return-Path: <linux-kernel-owner+w=401wt.eu-S932431AbXDJCKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431AbXDJCKh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 22:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932456AbXDJCKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 22:10:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38159 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932431AbXDJCKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 22:10:36 -0400
Date: Mon, 9 Apr 2007 22:10:29 -0400
From: Dave Jones <davej@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>, Eric Anholt <eric@anholt.net>,
       Keith Packard <keithp@keithp.com>
Subject: Re: [PATCH] intel_agp: fix G965 GTT size detect
Message-ID: <20070410021029.GG1994@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>, Eric Anholt <eric@anholt.net>,
	Keith Packard <keithp@keithp.com>
References: <20070410014248.GA17932@zhen-devel.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070410014248.GA17932@zhen-devel.sh.intel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2007 at 09:42:48AM +0800, Wang Zhenyu wrote:
 > 
 > Dave, 
 > 
 > On G965, I810_PGETBL_CTL is a mmio offset, but we wrongly take it
 > as pci config space offset in detecting GTT size. This one line patch
 > fixs this. 

Thanks, applied, and pushed on to Linus for .21

Be careful with trailing whitespace btw, git-applymbox complains loudly
when merging such patches. (I fixed it up by hand this time)

	Dave

-- 
http://www.codemonkey.org.uk
