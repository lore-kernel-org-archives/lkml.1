Return-Path: <linux-kernel-owner+w=401wt.eu-S1754903AbYH1PR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbYH1PR4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 11:17:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753112AbYH1PRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 11:17:47 -0400
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:37879 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbYH1PRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 11:17:47 -0400
Date: Thu, 28 Aug 2008 16:17:44 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] checkpatch: complex macros need to ignore comments
Message-ID: <20080828151744.GD27763@brain>
References: <1214998278-11767-1-git-send-email-apw@shadowen.org> <1214998278-11767-4-git-send-email-apw@shadowen.org> <alpine.LNX.1.10.0807052043210.28765@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0807052043210.28765@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 05, 2008 at 08:44:35PM +0200, Jan Engelhardt wrote:
> 
> On Wednesday 2008-07-02 13:31, Andy Whitcroft wrote:
> 
> >Ensure we ignore comments in complex macro detection else we incorrectly
> >report this:
> >
> >	#define PFM_GROUP_PERM_ANY     -1      /* any user/group */
> 
> Does it also catch this ugly piece from dcache.c?
> 
> 
> #define DCACHE_NFSFS_RENAMED  0x0002    /* this dentry has been "silly
>                                          * renamed" and has to be
>                                          * deleted on the last dput()
>                                          */

Yeah it should indeed.  A quick check with the current version seems to
confirm that.

-apw
