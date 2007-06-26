Return-Path: <linux-kernel-owner+w=401wt.eu-S1756197AbXFZDbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197AbXFZDbR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 23:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbXFZDbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 23:31:08 -0400
Received: from outbound-mail-14.bluehost.com ([69.89.18.114]:56656 "HELO
	outbound-mail-14.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752516AbXFZDbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 23:31:07 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Date: Mon, 25 Jun 2007 20:30:52 -0700
User-Agent: KMail/1.9.7
Cc: Jesse Barnes <jesse.barnes@intel.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Justin Piszcz <jpiszcz@lucidpixels.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
References: <200706251434.43863.jesse.barnes@intel.com> <m1bqf3tu06.fsf@ebiederm.dsl.xmission.com> <200706252029.35574.jbarnes@virtuousgeek.org>
In-Reply-To: <200706252029.35574.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706252030.52611.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.103.130.182 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 25, 2007 8:29:35 pm Jesse Barnes wrote:
> Is there an is_cpu() check to differentiate between those?  Anyway I'd
> rather not enable it unless we see reports though...  So far I've only seen
> reports of this problem on some recent Intel based systems.

Oh, and FYI I've seen new systems with a default mapping type of WB, with a 
few uncached holes for MMIO.  That means PAT will be absolutely required on 
those systems if we want to use WC for the framebuffer or other memory.  I 
hope it's ready for mainline soon...

Jesse
