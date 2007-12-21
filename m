Return-Path: <linux-kernel-owner+w=401wt.eu-S1755094AbXLUG1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094AbXLUG1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 01:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbXLUG1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 01:27:09 -0500
Received: from an-out-0708.google.com ([209.85.132.247]:18610 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbXLUG1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 01:27:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=iIBIf49AIGTn9COcnGo2UzZxv1Od13PFIiHC4U+2WpdbfcdmA0sjX6G4Li5TdFAZ4Y99ylOmDS4UbNzgNV2gGUD9WUr6klsm1e2IJD+5PzDuSWi6w1sr902h5YbV3aeZfs0sLyqrG10P20Al4RUPg++S/TeJXIBtfxs43U0QthI=
Subject: Re: [PATCH] misc: Removal of final callers using fastcall
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>
In-Reply-To: <20071220183029.86ac61e4.akpm@linux-foundation.org>
References: <1197502706.21291.49.camel@brick>
	 <20071220183029.86ac61e4.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 20 Dec 2007 22:27:02 -0800
Message-Id: <1198218422.8584.1.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-12-20 at 18:30 -0800, Andrew Morton wrote:
> On Wed, 12 Dec 2007 15:38:26 -0800 Harvey Harrison <harvey.harrison@gmail.com> wrote:
> 
> > Andrew, I'm not sure who is best to hit with these final dribs and
> > drabs removing fastcall.  Once all of these have hit Linus' tree
> > I will send a final patch deleting the include/linux/linkage.h
> > definitions as well as any remaining occurances.
> 
> Yes, that's a good approach, thanks.  Wait until the tree is fastcall-clean
> and then kill the definition(s).
> 
> I think I skipped rather a lot of remove-fastcall patches because a)
> suitable maintainers were cc'ed and b) I was going through a
> suicidal-over-bug-reports phase.
> 
> Please keep them coming - I've always disliked fastcall.

Once I see these have hit the main tree, I'll send patch getting any
more that have snuck in for the next rc.  After that there should be
few enough left that I can send you a small patch for the next rc
with the definition removal as well.

I'll keep on top of these.

Harvey



