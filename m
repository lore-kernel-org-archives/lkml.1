Return-Path: <linux-kernel-owner+w=401wt.eu-S1765152AbYBNU5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765152AbYBNU5z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 15:57:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753003AbYBNU5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 15:57:47 -0500
Received: from sj-iport-2.cisco.com ([171.71.176.71]:10334 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbYBNU5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 15:57:46 -0500
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] unhide CONFIG_DEBUG_SECTION_MISMATCH
X-Message-Flag: Warning: May contain useful information
References: <200802142054.m1EKs49x023091@agora.fsl.cs.sunysb.edu>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 14 Feb 2008 12:57:41 -0800
In-Reply-To: <200802142054.m1EKs49x023091@agora.fsl.cs.sunysb.edu> (Erez Zadok's message of "Thu, 14 Feb 2008 15:54:04 -0500")
Message-ID: <adabq6jqmre.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 Feb 2008 20:57:42.0138 (UTC) FILETIME=[3D9435A0:01C86F4C]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > I can indeed try to re-make, passing CONFIG_DEBUG_SECTION_MISMATCH=y on the
 > command line, but I can't turn on the option in my .config.  That's because
 > the option depends on "UNDEFINED".  (Was that an attempt to "hide" the
 > option?  Why?)  The following small patch allows me to set the option in my
 > .config.

It seems this was intentional, see the log for e5f95c8b:

    kbuild: print only total number of section mismatces found
    
    We have too many section mismatches detected at the moment.
    So silence modpost and prevent the option from being
    set in a typical allyesconfig build.
    
    Tell the user how to see all the deteils in the summary
    message from modpost.
    
    Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
