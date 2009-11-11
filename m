Return-Path: <linux-kernel-owner+w=401wt.eu-S1755948AbZKKMid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948AbZKKMid (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 07:38:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbZKKMic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 07:38:32 -0500
Received: from one.firstfloor.org ([213.235.205.2]:34485 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbZKKMic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 07:38:32 -0500
Date: Wed, 11 Nov 2009 13:38:30 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Izik Eidus <ieidus@redhat.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Nick Piggin <npiggin@suse.de>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Andi Kleen <andi@firstfloor.org>, Wu Fengguang <fengguang.wu@intel.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/6] mm: CONFIG_MMU for PG_mlocked
Message-ID: <20091111123829.GA16628@basil.fritz.box>
References: <Pine.LNX.4.64.0911102142570.2272@sister.anvils> <Pine.LNX.4.64.0911102155180.2816@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0911102155180.2816@sister.anvils>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 09:59:23PM +0000, Hugh Dickins wrote:
> Remove three degrees of obfuscation, left over from when we had
> CONFIG_UNEVICTABLE_LRU.  MLOCK_PAGES is CONFIG_HAVE_MLOCKED_PAGE_BIT
> is CONFIG_HAVE_MLOCK is CONFIG_MMU.  rmap.o (and memory-failure.o)
> are only built when CONFIG_MMU, so don't need such conditions at all.

Thanks.  The memory-failure.c change looks good and indeeds
it's overall less confusing.
-Andi
