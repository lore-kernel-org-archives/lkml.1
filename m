Return-Path: <linux-kernel-owner+w=401wt.eu-S1751901AbYJ0R4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901AbYJ0R4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 13:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbYJ0R4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 13:56:45 -0400
Received: from ox1.aei.mpg.de ([194.94.224.6]:52595 "EHLO ox1.aei.mpg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbYJ0R4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 13:56:43 -0400
Date: Mon, 27 Oct 2008 18:57:19 +0100
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, tomas.winkler@intel.com, kernel@nn7.de,
       linux-wireless@vger.kernel.org
Subject: Re: Suspend to RAM regression in 2.6.28-rc2 (bisected)
Message-ID: <20081027175719.GA5759@localhost.aei.mpg.de>
References: <20081027162054.GA4015@localhost.aei.mpg.de> <200810271839.39236.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810271839.39236.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 27.Oct'08 at 18:39:38 +0100, Rafael J. Wysocki wrote:
> On Monday, 27 of October 2008, Carlos R. Mafra wrote:
> > Hi,
> > 
> > So I managed to bisect my suspend to RAM regression in 2.6.27-rc2
> > to commit 3b7ee69d0caefbdb85a606a98bff841b8c63b97e ("mac80211: disassociate 
> > when moving to new BSS") by Tomas Winkler (Cc:-ed).
> > 
> > Unfortunately it doesn't revert cleanly so I can't double check it.
> 
> Why are you saying it doesn't revert cleanly?  For me it does revert without
> rejects from 2.6.28-rc2.

I get this

[mafra@localhost:linux-2.6]$ git checkout v2.6.28-rc2 -b s2ram
Switched to a new branch "s2ram"
[mafra@localhost:linux-2.6]$ git revert 3b7ee69d
warning: too many files, skipping inexact rename detection
Auto-merged net/mac80211/mlme.c
CONFLICT (content): Merge conflict in net/mac80211/mlme.c
Automatic revert failed.  After resolving the conflicts,
mark the corrected paths with 'git add <paths>' or 'git rm <paths>' and commit the result.

I don't know what is happening here :-(
