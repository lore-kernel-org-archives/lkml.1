Return-Path: <linux-kernel-owner+w=401wt.eu-S1755696AbZHGJgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696AbZHGJgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 05:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbZHGJgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 05:36:21 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60765 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410AbZHGJgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 05:36:20 -0400
Date: Fri, 7 Aug 2009 10:34:59 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: sam@ravnborg.org, hpa@zytor.com, alain@knaff.lu,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 4/6] Add support for LZO-compressed kernels for ARM
Message-ID: <20090807093459.GB20011@n2100.arm.linux.org.uk>
References: <20090731093107.GA29704@merkur.ravnborg.org> <1249311501-23102-1-git-send-email-albin.tonnerre@free-electrons.com> <1249311501-23102-2-git-send-email-albin.tonnerre@free-electrons.com> <1249311501-23102-3-git-send-email-albin.tonnerre@free-electrons.com> <1249311501-23102-4-git-send-email-albin.tonnerre@free-electrons.com> <20090806224055.GH31579@n2100.arm.linux.org.uk> <20090807092423.GA4455@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090807092423.GA4455@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 11:24:52AM +0200, Albin Tonnerre wrote:
> I also happen to have issues related to the linker not finding __aeabi_uidivmod,
> but only when compiling with CONFIG_CC_OPTIMIZE_FOR_SIZE. Is it similar for you,
> or does it also fail when compiling with -O2 ?

I tend not to build with -O2 because it seems to tickle compiler bugs
(which is the reverse of -Os on x86.)  I'll give it a go over the
next few days.
