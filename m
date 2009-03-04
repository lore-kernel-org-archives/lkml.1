Return-Path: <linux-kernel-owner+w=401wt.eu-S1756851AbZCDBPE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851AbZCDBPE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 20:15:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753239AbZCDBOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 20:14:50 -0500
Received: from mga11.intel.com ([192.55.52.93]:64670 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071AbZCDBOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 20:14:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,297,1233561600"; 
   d="scan'208";a="670117386"
Subject: Re: 2.6.29-rc6-git7: Reported regressions from 2.6.28
From: Zhang Rui <rui.zhang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>, eric@anholt.net,
       airlied@linux.ie
In-Reply-To: <KiHv0irKPzE.A.l3.hUarJB@chimera>
References: <KiHv0irKPzE.A.l3.hUarJB@chimera>
Content-Type: text/plain
Date: Wed, 04 Mar 2009 09:15:12 +0800
Message-Id: <1236129312.32297.259.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-04 at 03:22 +0800, Rafael J. Wysocki wrote:

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12705
> Subject         : X200: Brightness broken since 2.6.29-rc4-58-g4c098bc
> Submitter       : Nico Schottelius <nico-linux-20090213@schottelius.org>
> Date            : 2009-02-13 9:33 (19 days old)
> References      : http://marc.info/?l=linux-kernel&m=123451768406825&w=4
> Handled-By      : Len Brown <lenb@kernel.org>
> 

e806b4957412bf472d826bd8cc571da041248799 is first bad commit
commit e806b4957412bf472d826bd8cc571da041248799
Author: Eric Anholt <eric@anholt.net>
Date:   Thu Jan 22 09:56:58 2009 -0800

    drm/i915: Suppress GEM teardown on X Server exit in KMS mode.
    
    Fixes hangs when starting X for the second time.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

http://marc.info/?l=linux-kernel&m=123479975503827&w=2

thanks,
rui


