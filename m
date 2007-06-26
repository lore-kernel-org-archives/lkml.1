Return-Path: <linux-kernel-owner+w=401wt.eu-S1758192AbXFZPIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758192AbXFZPIP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 11:08:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756197AbXFZPIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 11:08:00 -0400
Received: from outbound-mail-36.bluehost.com ([69.89.20.190]:47607 "HELO
	outbound-mail-36.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756770AbXFZPH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 11:07:59 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Date: Tue, 26 Jun 2007 08:07:45 -0700
User-Agent: KMail/1.9.7
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Justin Piszcz <jpiszcz@lucidpixels.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
References: <200706251434.43863.jesse.barnes@intel.com> <200706252030.52611.jbarnes@virtuousgeek.org> <20070626150348.GB7877@one.firstfloor.org>
In-Reply-To: <20070626150348.GB7877@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706260807.45362.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.103.130.182 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 26, 2007 8:03:48 am Andi Kleen wrote:
> On Mon, Jun 25, 2007 at 08:30:52PM -0700, Jesse Barnes wrote:
> > Oh, and FYI I've seen new systems with a default mapping type of WB, with
> > a few uncached holes for MMIO.  That means PAT will be absolutely
> > required on those systems if we want to use WC for the framebuffer or
> > other memory.
>
> Why? As long as there are still MTRRs free you could use them for
> WC even in this setup.

According to the manual, you can't use WC or WT MTRRs on top of a WB MTRR 
range.  Only UC MTRRs can override WB MTRRs, but PAT doesn't have this 
restriction.

Jesse

