Return-Path: <linux-kernel-owner+w=401wt.eu-S1757972AbZEFRu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972AbZEFRu7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 13:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753628AbZEFRuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 13:50:50 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39134 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753323AbZEFRuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 13:50:50 -0400
Date: Wed, 6 May 2009 19:47:05 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Chris Wright <chrisw@redhat.com>, Izik Eidus <ieidus@redhat.com>,
       Rik van Riel <riel@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       device@lanana.org, linux-mm@kvack.org, nickpiggin@yahoo.com.au
Subject: Re: [PATCH 3/6] ksm: change the KSM_REMOVE_MEMORY_REGION ioctl.
Message-ID: <20090506174705.GB16078@random.random>
References: <1241475935-21162-3-git-send-email-ieidus@redhat.com> <1241475935-21162-4-git-send-email-ieidus@redhat.com> <4A00DF9B.1080501@redhat.com> <4A014C7B.9080702@redhat.com> <Pine.LNX.4.64.0905061110470.3519@blonde.anvils> <20090506133434.GX16078@random.random> <4A019719.7030504@redhat.com> <Pine.LNX.4.64.0905061739540.5934@blonde.anvils> <20090506164945.GD15712@x200.localdomain> <Pine.LNX.4.64.0905061754250.7350@blonde.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0905061754250.7350@blonde.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 05:57:14PM +0100, Hugh Dickins wrote:
> No need to decide today anyway: let's see how others feel.

It guess is decided today, the length of this thread is enough
regardless of its content. To me madvise looks overdesign but then I'm
also sure KSM is here to stay and it'll soon swap too, so I think it's
no problem at all, if part of it is always present in the VM
core. KSM=N must stay for embedded. Not sure if it worth to keep
KSM=M.
