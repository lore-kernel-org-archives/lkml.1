Return-Path: <linux-kernel-owner+w=401wt.eu-S1754522AbZBQRZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbZBQRZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 12:25:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbZBQRZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 12:25:27 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53286 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841AbZBQRZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 12:25:25 -0500
Message-ID: <499AF2DF.3060101@sandeen.net>
Date: Tue, 17 Feb 2009 11:24:47 -0600
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Carsten Aulbert <carsten.aulbert@aei.mpg.de>
CC: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: xfs problems (possibly after upgrading from linux kernel 2.6.27.10
 to .14)
References: <499ACE6C.4060304@aei.mpg.de>
In-Reply-To: <499ACE6C.4060304@aei.mpg.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Carsten Aulbert wrote:
> Hi all,
> 
> within the past few days we hit many XFS internal errors like these. Are these
> errors known (and possibly already fixed)? I checked the commits till 
> 2.6.27.17 and there does not seem anything related to this.
> 
> Do you need more information or can I send these nodes into a re-install?
> 
> Cheers
> 
> Carsten
> 
> PS: Please CC me, as I'm currently not on this list.

It'd be worth running xfs_repair on one of these nodes, I think, to see
if you're encountering on-disk corruption, which is what this looks like.

Anything funky about your storage?  Any IO/storage issues before this?
Does going back to .10 make it go away?

-Eric
