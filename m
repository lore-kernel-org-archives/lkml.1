Return-Path: <linux-kernel-owner+w=401wt.eu-S1762050AbZEMXZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762050AbZEMXZr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 19:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754225AbZEMXZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 19:25:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45313 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753958AbZEMXZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 19:25:32 -0400
Date: Wed, 13 May 2009 16:25:20 -0700
From: Chris Wright <chrisw@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Izik Eidus <ieidus@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, kvm@vger.kernel.org, avi@redhat.com,
       aarcange@redhat.com, chrisw@redhat.com, mtosatti@redhat.com,
       hugh@veritas.com
Subject: Re: [PATCH 5/5] add ksm kernel shared memory driver.
Message-ID: <20090513232520.GN12533@x200.localdomain>
References: <1240191366-10029-1-git-send-email-ieidus@redhat.com> <1240191366-10029-2-git-send-email-ieidus@redhat.com> <1240191366-10029-3-git-send-email-ieidus@redhat.com> <1240191366-10029-4-git-send-email-ieidus@redhat.com> <1240191366-10029-5-git-send-email-ieidus@redhat.com> <1240191366-10029-6-git-send-email-ieidus@redhat.com> <20090513161739.d801ab67.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090513161739.d801ab67.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> Breaks ppc64 allmodcofnig because that architecture doesn't export its
> copy_user_page() to modules.

Things like this and updating to use madvise() I think all point towards
s/tristate/bool/.  I don't think CONFIG_KSM=M has huge benefit.

thanks,
-chris
