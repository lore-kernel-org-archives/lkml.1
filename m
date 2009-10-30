Return-Path: <linux-kernel-owner+w=401wt.eu-S1756135AbZJ3Bas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135AbZJ3Bas (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 21:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753111AbZJ3Bar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 21:30:47 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:56535 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753013AbZJ3Baq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 21:30:46 -0400
Date: Thu, 29 Oct 2009 21:30:37 -0400 (EDT)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@dr-wily.mit.edu
To: Greg Ungerer <gerg@snapgear.com>
cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH v4 7/7] m68knommu: Split the .init section into
 INIT_TEXT_SECTION and INIT_DATA_SECTION.
In-Reply-To: <4AEA3DC9.7080205@snapgear.com>
Message-ID: <alpine.DEB.1.10.0910292116511.24830@dr-wily.mit.edu>
References: <alpine.DEB.1.10.0910142041520.6638@dr-wily.mit.edu> <1255886635-17371-7-git-send-email-tabbott@ksplice.com> <4AEA3DC9.7080205@snapgear.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Oct 2009, Greg Ungerer wrote:

> Hi Tim,
> 
> The whole series applied and ran fine for me!
> (Of course excepting the define name clash in 1/7)

Thanks for your patience debugging this patch series!

> Do you want me to push these into m68knommu.git?

Yes, that'd be great.  Do you expect these to end up in 2.6.32?  I have an 
API change to INIT_DATA_SECTION that I want to put in 2.6.32 to fix a tiny 
regression on blackfin, and I'd like to know which change is likely to get 
merged first (since the API change will likely conflict).

	-Tim Abbott
