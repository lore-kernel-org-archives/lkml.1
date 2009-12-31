Return-Path: <linux-kernel-owner+w=401wt.eu-S1753111AbZLaDDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111AbZLaDDQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 22:03:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbZLaDDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 22:03:15 -0500
Received: from mga14.intel.com ([143.182.124.37]:45974 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692AbZLaDDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 22:03:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="228000455"
Date: Thu, 31 Dec 2009 11:03:11 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Quentin Barnes <qbarnes+nfs@yahoo-inc.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>, Steven Whitehouse <swhiteho@redhat.com>
Subject: Re: [RFC][PATCH 2/2] readahead: avoid page-by-page reads on
	POSIX_FADV_RANDOM
Message-ID: <20091231030311.GA12517@localhost>
References: <20091225000717.GA26949@yahoo-inc.com> <87aax18xms.fsf@basil.nowhere.org> <20091230051540.GA16308@localhost> <20091230052402.GB26364@localhost> <873a2s8hmp.fsf@basil.nowhere.org> <20091231013935.GA6570@localhost> <20091231025343.GA11327@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091231025343.GA11327@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 31, 2009 at 10:53:43AM +0800, Wu Fengguang wrote:

> So how about add a FMODE_HINT_RANDOM_READ bit to file->f_mode?
> Modifying it at fadvise() time at least won't disturb the existing
> open-time-modify-only f_mode bits..

Ah it seems file->f_flags (modified under f_lock) is ideal candidate :)

Thanks,
Fengguang

