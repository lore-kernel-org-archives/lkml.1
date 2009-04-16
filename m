Return-Path: <linux-kernel-owner+w=401wt.eu-S1755688AbZDPLkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688AbZDPLkd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 07:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753723AbZDPLkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 07:40:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38070 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753050AbZDPLkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 07:40:21 -0400
Date: Thu, 16 Apr 2009 13:39:31 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Izik Eidus <ieidus@redhat.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
       avi@redhat.com, chrisw@redhat.com, mtosatti@redhat.com,
       hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 4/4] add ksm kernel shared memory driver.
Message-ID: <20090416113931.GF4524@random.random>
References: <1239249521-5013-1-git-send-email-ieidus@redhat.com> <1239249521-5013-2-git-send-email-ieidus@redhat.com> <1239249521-5013-3-git-send-email-ieidus@redhat.com> <1239249521-5013-4-git-send-email-ieidus@redhat.com> <1239249521-5013-5-git-send-email-ieidus@redhat.com> <20090414150929.174a9b25.akpm@linux-foundation.org> <49E67F17.1070805@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E67F17.1070805@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15, 2009 at 05:43:03PM -0700, Jeremy Fitzhardinge wrote:
> Shouldn't that be kmap_atomic's job anyway?  Otherwise it would be hard to 

No because those are full noops in no-highmem kernels. I commented in
other email why I think it's safe thanks to the wrprotect + smp tlb
flush of the userland PTE.
