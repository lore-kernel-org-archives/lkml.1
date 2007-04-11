Return-Path: <linux-kernel-owner+w=401wt.eu-S1752976AbXDKOpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbXDKOpw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 10:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752929AbXDKOpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 10:45:52 -0400
Received: from outbound-fra.frontbridge.com ([62.209.45.174]:34897 "EHLO
	outbound2-fra-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752914AbXDKOpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 10:45:47 -0400
X-BigFish: VP
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Date: Wed, 11 Apr 2007 16:46:09 +0200
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: "Andi Kleen" <ak@suse.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64: prevent auto select of mwait_idle for AMD
 CPUs
Message-ID: <20070411144609.GE12476@alberich.amd.com>
References: <20070410172425.GE24680@alberich.amd.com>
 <200704102011.18752.ak@suse.de>
MIME-Version: 1.0
In-Reply-To: <200704102011.18752.ak@suse.de>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 11 Apr 2007 14:45:37.0005 (UTC)
 FILETIME=[111E81D0:01C77C48]
X-WSS-ID: 6A022B193283776996-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2007 at 08:11:18PM +0200, Andi Kleen wrote:
> On Tuesday 10 April 2007 19:24:25 Andreas Herrmann wrote:
> > This fix is needed for AMD family 10h CPUs.
> > 
> > It prevents auto select of mwait_idle for AMD CPUs.
> > MWAIT does not enter C-states on family 10h and more
> > power saving is reached by entering C1 with
> > default_idle.
> > 
> > The patch also adds an idle=mwait command line option
> > to select mwait_idle for benchmarking.
> 
> I already did my own patch earlier. Applied for reference.
> 
> -Andi

Great. Your patch is the better solution.


Regards,

Andreas



