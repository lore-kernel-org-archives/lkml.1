Return-Path: <linux-kernel-owner+w=401wt.eu-S1758264AbXFZPD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264AbXFZPD6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 11:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756589AbXFZPDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 11:03:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42061 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755903AbXFZPDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 11:03:49 -0400
Date: Tue, 26 Jun 2007 17:03:48 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Jesse Barnes <jesse.barnes@intel.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Justin Piszcz <jpiszcz@lucidpixels.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Message-ID: <20070626150348.GB7877@one.firstfloor.org>
References: <200706251434.43863.jesse.barnes@intel.com> <m1bqf3tu06.fsf@ebiederm.dsl.xmission.com> <200706252029.35574.jbarnes@virtuousgeek.org> <200706252030.52611.jbarnes@virtuousgeek.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706252030.52611.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2007 at 08:30:52PM -0700, Jesse Barnes wrote:
> Oh, and FYI I've seen new systems with a default mapping type of WB, with a 
> few uncached holes for MMIO.  That means PAT will be absolutely required on 
> those systems if we want to use WC for the framebuffer or other memory. 

Why? As long as there are still MTRRs free you could use them for 
WC even in this setup.

-Andi
