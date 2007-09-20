Return-Path: <linux-kernel-owner+w=401wt.eu-S1758172AbXITRK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758172AbXITRK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 13:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbXITRKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 13:10:17 -0400
Received: from outbound-mail-13.bluehost.com ([69.89.18.113]:57692 "HELO
	outbound-mail-13.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751459AbXITRKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 13:10:15 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: MTRR initialization
Date: Thu, 20 Sep 2007 10:08:53 -0700
User-Agent: KMail/1.9.7
Cc: Jesse Barnes <jesse.barnes@intel.com>, Howard Chu <hyc@symas.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <46EAB7DA.10507@symas.com> <p73d4wdal00.fsf@bingen.suse.de> <200709200803.31795.jbarnes@virtuousgeek.org>
In-Reply-To: <200709200803.31795.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709201008.53728.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 209.164.175.194 authed with jbarnes@virtuousgeek.org}
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box128.bluehost.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [642 12] / [47 12]
X-AntiAbuse: Sender Address Domain - virtuousgeek.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 20, 2007, Jesse Barnes wrote:
> On Wednesday, September 19, 2007 11:50:23 pm Andi Kleen wrote:
> > Jesse Barnes <jesse.barnes@intel.com> writes:
> > > To do this in a nicer way (and be less vulnerable to similar BIOS
> > > funkiness) the kernel really needs full PAT support.  That should
> > > allow WC over WB and WC over UC mappings to occur, at least if
> > > I'm remembering the docs right...
> >
> > PAT only really helps for device driver performance optimizations.
> > But if the basic WB MTRRs are wrong PAT cannot really salvage it.
>
> Look at the original bug report.  There's a bug WB region so any
                                              ^^^
                                          err big
