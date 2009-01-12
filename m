Return-Path: <linux-kernel-owner+w=401wt.eu-S1757801AbZALV4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757801AbZALV4m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 16:56:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbZALV4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 16:56:34 -0500
Received: from one.firstfloor.org ([213.235.205.2]:51022 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbZALV4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 16:56:33 -0500
Date: Mon, 12 Jan 2009 23:11:03 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tim Abbott <tabbott@MIT.EDU>, andi@firstfloor.org, jbarnold@MIT.EDU,
       linux-kernel@vger.kernel.org, vda.linux@googlemail.com, andersk@MIT.EDU,
       wdaher@MIT.EDU, knikanth@suse.de
Subject: Re: [PATCH 1/7] Make section names compatible with -ffunction-sections -fdata-sections
Message-ID: <20090112221103.GJ23848@one.firstfloor.org>
References: <1228521840-3886-1-git-send-email-jbarnold@mit.edu> <1228521840-3886-2-git-send-email-jbarnold@mit.edu> <8763lxwv0d.fsf@basil.nowhere.org> <alpine.DEB.2.00.0812311410070.2230@vinegar-pot.mit.edu> <20081231195215.GU496@one.firstfloor.org> <alpine.DEB.2.00.0812311649180.2230@vinegar-pot.mit.edu> <20090101083230.34cffeac.akpm@linux-foundation.org> <alpine.DEB.2.00.0901011725320.10164@vinegar-pot.mit.edu> <20090112135127.7a0bb392.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090112135127.7a0bb392.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So we `make it possible to build the kernel > with "gcc
> -ffunction-sections -fdata-sections"'.  So what?  Where is the value in
> that?

The original reason was that it allows the linker to drop unused
functions automatically. That is a good thing by itself -- e.g.
if it was universal we could avoid a lot of #ifdefs.  And it
also turned out that standard kernel builds get smaller by it iirc.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
