Return-Path: <linux-kernel-owner+w=401wt.eu-S1756483AbZEEAzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483AbZEEAzx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 20:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754328AbZEEAzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 20:55:40 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:36069 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023AbZEEAzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 20:55:39 -0400
X-IronPort-AV: E=Sophos;i="4.40,294,1238976000"; 
   d="scan'208";a="298263208"
Date: Mon, 4 May 2009 17:55:39 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-usb@vger.kernel.org, greg@kroah.com, linux-scsi@vger.kernel.org,
       netdev@vger.kernel.org, arjan@infradead.org
Subject: Re: [PATCH 1/5] initdev:kernel: Asynchronously-discovered device
	synchronization, v5
Message-ID: <20090505005539.GG29124@cuplxvomd02.corp.sa.net>
References: <1241272876.3639.27.camel@mulgrave.int.hansenpartnership.com> <Pine.LNX.4.44L0.0905021335150.26241-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0905021335150.26241-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Authentication-Results: sj-dkim-3; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 02, 2009 at 01:55:45PM -0400, Alan Stern wrote:
> On Sat, 2 May 2009, James Bottomley wrote:
...
> > What I'm getting at is that I don't see the benefit of this in the light
> > of Arjan's async boot system, which can also tell us when all discovery
> > is complete ... what added benefit am I missing here?
> 
> How does Arjan's async boot system tell use when all discovery is
> complete?  AFAICS, it only tells you when all its async tasks are
> finished.  But device discovery and registration sometimes use other
> asynchronous techniques which Arjan's code is unaware of.  Examples:  
> the USB khubd thread, the USB mass-storage scanning thread, and the
> SCSI async-scanning thread.

The patchset does use Arjan's asynchronous function calls in one place.  If
there are other places it can be used to get equivalent functionality, I'll
be happy to do so.

> Alan Stern

David VomLehn
