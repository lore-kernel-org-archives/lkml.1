Return-Path: <linux-kernel-owner+w=401wt.eu-S1760073AbZEFQoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760073AbZEFQoe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 12:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751083AbZEFQoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 12:44:25 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:42720 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbZEFQoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 12:44:24 -0400
Date: Wed, 6 May 2009 17:41:37 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Izik Eidus <ieidus@redhat.com>
cc: Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       chrisw@redhat.com, alan@lxorguk.ukuu.org.uk, device@lanana.org,
       linux-mm@kvack.org, nickpiggin@yahoo.com.au
Subject: Re: [PATCH 3/6] ksm: change the KSM_REMOVE_MEMORY_REGION ioctl.
In-Reply-To: <4A019719.7030504@redhat.com>
Message-ID: <Pine.LNX.4.64.0905061739540.5934@blonde.anvils>
References: <1241475935-21162-1-git-send-email-ieidus@redhat.com>
 <1241475935-21162-2-git-send-email-ieidus@redhat.com>
 <1241475935-21162-3-git-send-email-ieidus@redhat.com>
 <1241475935-21162-4-git-send-email-ieidus@redhat.com> <4A00DF9B.1080501@redhat.com>
 <4A014C7B.9080702@redhat.com> <Pine.LNX.4.64.0905061110470.3519@blonde.anvils>
 <20090506133434.GX16078@random.random> <4A019719.7030504@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 May 2009, Izik Eidus wrote:
> Andrea Arcangeli wrote:
> > On Wed, May 06, 2009 at 12:16:52PM +0100, Hugh Dickins wrote:
> >   
> >
> > > p.s.  I wish you'd chosen different name than KSM - the kernel
> > > has supported shared memory for many years - and notice ksm.c itself
> > > says "Memory merging driver".  "Merge" would indeed have been a less
> > > ambiguous term than "Share", but I think too late to change that now
> > > - except possibly in the MADV_ flag names?
> > >     
> >
> > I don't actually care about names, so I leave this to other to discuss.
> >   
> Well, There is no real problem changing the name, any suggestions?

mm/merge.c or mm/mmerge.c: the module formerly known as KSM ?

Hugh
