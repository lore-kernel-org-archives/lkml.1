Return-Path: <linux-kernel-owner+w=401wt.eu-S1760556AbZEFPkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760556AbZEFPkX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 11:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754477AbZEFPkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 11:40:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57898 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715AbZEFPkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 11:40:07 -0400
Date: Wed, 6 May 2009 08:36:50 -0700
From: Chris Wright <chrisw@redhat.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hugh@veritas.com>, Izik Eidus <ieidus@redhat.com>,
       Rik van Riel <riel@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, chrisw@redhat.com,
       alan@lxorguk.ukuu.org.uk, device@lanana.org, linux-mm@kvack.org,
       nickpiggin@yahoo.com.au
Subject: Re: [PATCH 3/6] ksm: change the KSM_REMOVE_MEMORY_REGION ioctl.
Message-ID: <20090506153650.GA15712@x200.localdomain>
References: <1241475935-21162-1-git-send-email-ieidus@redhat.com> <1241475935-21162-2-git-send-email-ieidus@redhat.com> <1241475935-21162-3-git-send-email-ieidus@redhat.com> <1241475935-21162-4-git-send-email-ieidus@redhat.com> <4A00DF9B.1080501@redhat.com> <4A014C7B.9080702@redhat.com> <Pine.LNX.4.64.0905061110470.3519@blonde.anvils> <20090506133434.GX16078@random.random> <Pine.LNX.4.64.0905061453320.21067@blonde.anvils> <20090506144558.GZ16078@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506144558.GZ16078@random.random>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrea Arcangeli (aarcange@redhat.com) wrote:
> On Wed, May 06, 2009 at 03:25:25PM +0100, Hugh Dickins wrote:
> > silently ignore may fit better with whether module has been loaded yet
> > (we can keep a list of what's registered, for when module is loaded).
> 
> NOTE: it will not fail if the module isn't loaded yet. It must
> succeed! Otherwise it would also need to fail after it succeeded if we
> unload the module later...

I actually see little value in it even being modular.
