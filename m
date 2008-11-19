Return-Path: <linux-kernel-owner+w=401wt.eu-S1754213AbYKSRbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbYKSRbS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 12:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbYKSRbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 12:31:03 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45503 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752770AbYKSRbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 12:31:01 -0500
Date: Wed, 19 Nov 2008 09:30:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Mingarelli, Thomas" <Thomas.Mingarelli@hp.com>
Cc: Bernhard Walle <bwalle@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "wim@iguana.be" <wim@iguana.be>,
       "stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH] [WATCHDOG] [hpwdt] Set the mapped BIOS address space as
 executable
Message-Id: <20081119093041.1af8fd7e.akpm@linux-foundation.org>
In-Reply-To: <183C1D5A376DE343AA8F94FC2A1EC1493AA5CEE7AB@GVW1091EXB.americas.hpqcorp.net>
References: <1226674023-5374-1-git-send-email-bwalle@suse.de>
	<20081118143015.72af31d3.akpm@linux-foundation.org>
	<20081118233229.294270fb@kopernikus.site>
	<183C1D5A376DE343AA8F94FC2A1EC1493AA5CEE7AB@GVW1091EXB.americas.hpqcorp.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2008 14:05:06 +0000 "Mingarelli, Thomas" <Thomas.Mingarelli@hp.com> wrote:

> 
> -----Original Message-----
> > From: Bernhard Walle [mailto:bwalle@suse.de]
> > Sent: Tuesday, November 18, 2008 4:32 PM
> > To: Andrew Morton
> > Cc: Mingarelli, Thomas; linux-kernel@vger.kernel.org; wim@iguana.be; stable@kernel.org
> > Subject: Re: [PATCH] [WATCHDOG] [hpwdt] Set the mapped BIOS address space as executable
> > 
> > * Andrew Morton [2008-11-18 14:30]:
> > >
> > > This is also needed in 2.6.27.x, yes?
> > 
> > Right. But I was waiting for feedback from the author since I'm really
> > not familiar with low level memory management and that driver. :(
> > 
>
> We have also verified that returning NOTIFY_OK from the hpwdt_pretimeout routine makes the KDUMP feature work correctly.
> 
> Bernhard pointed that out a week or so ago and we have since verified it.
> 

(top-posting repaired.  Please don't top-post!)

I haven't seen any patch which alters hpwdt_pretimeout() and there is
no such patch in linux-next.  Perhaps it got lost?

