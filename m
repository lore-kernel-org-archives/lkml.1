Return-Path: <linux-kernel-owner+w=401wt.eu-S1752130AbZHEPMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbZHEPMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 11:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751144AbZHEPMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 11:12:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47092 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbZHEPMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 11:12:18 -0400
Date: Wed, 5 Aug 2009 17:11:39 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, ieidus@redhat.com,
       riel@redhat.com, chrisw@redhat.com, nickpiggin@yahoo.com.au,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/12] ksm: pages_unshared and pages_volatile
Message-ID: <20090805151139.GY23385@random.random>
References: <Pine.LNX.4.64.0908031304430.16449@sister.anvils>
 <Pine.LNX.4.64.0908031311061.16754@sister.anvils>
 <20090804144920.bfc6a44f.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0908051216020.13195@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0908051216020.13195@sister.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 05, 2009 at 12:39:06PM +0100, Hugh Dickins wrote:
> procfs is not a nice interface for sysfs to be reading
> when it's asked to show pages_volatile!

Agreed, that is the real reason, grabbing that info from
slub/slab/slob (not so much from procfs) would be tricky.

Acked-by: Andrea Arcangeli <aarcange@redhat.com>
