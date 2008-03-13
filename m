Return-Path: <linux-kernel-owner+w=401wt.eu-S1752480AbYCMFp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480AbYCMFp0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 01:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbYCMFpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 01:45:19 -0400
Received: from eth7959.sa.adsl.internode.on.net ([150.101.82.22]:59750 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751372AbYCMFpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 01:45:19 -0400
Message-ID: <47D8BF76.8040105@davidnewall.com>
Date: Thu, 13 Mar 2008 16:15:26 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Daniel Phillips <phillips@phunq.net>
CC: Chris Friesen <cfriesen@nortel.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
References: <200803092346.17556.phillips@phunq.net> <200803121029.54108.phillips@phunq.net> <47D81CD9.6000802@nortel.com> <200803121556.15547.phillips@phunq.net>
In-Reply-To: <200803121556.15547.phillips@phunq.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Phillips wrote:
> So you design for the number of nines you need, taking all factors
> into account, and you design for the performance you need.  These are
> cut and dried calculations.  FUD has no place here.
>   

There's no FUD here.  The problem is that you didn't say that you've
designed this for only a few nines.  If you delete fsck from your
rationale, simply saying that you rely on UPS to give you time to flush
buffers, you have a much better story.  Certainly, once you've flushed
buffers and degraded to write-through mode, you're obviously as reliable
as ext2/3.

Your idea seems predicated on throwing large amounts of RAM at the
problem.  What I want to know is this: Is it really 25 times faster than
ext3 with an equally huge buffer cache?
