Return-Path: <linux-kernel-owner+w=401wt.eu-S1757823AbZEGAVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757823AbZEGAVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 20:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753134AbZEGAV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 20:21:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45755 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbZEGAV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 20:21:27 -0400
Date: Wed, 6 May 2009 17:19:07 -0700
From: Chris Wright <chrisw@redhat.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Hugh Dickins <hugh@veritas.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Rik van Riel <riel@redhat.com>,
       Izik Eidus <ieidus@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, chrisw@redhat.com, device@lanana.org,
       linux-mm@kvack.org, nickpiggin@yahoo.com.au
Subject: Re: [PATCH 2/6] ksm: dont allow overlap memory addresses
	registrations.
Message-ID: <20090507001907.GD16870@x200.localdomain>
References: <4A00DD4F.8010101@redhat.com> <4A015C69.7010600@redhat.com> <4A0181EA.3070600@redhat.com> <20090506131735.GW16078@random.random> <Pine.LNX.4.64.0905061424480.19190@blonde.anvils> <20090506140904.GY16078@random.random> <20090506152100.41266e4c@lxorguk.ukuu.org.uk> <Pine.LNX.4.64.0905061532240.25289@blonde.anvils> <20090506145641.GA16078@random.random> <20090507085547.24efb60f.minchan.kim@barrios-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507085547.24efb60f.minchan.kim@barrios-desktop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Minchan Kim (minchan.kim@gmail.com) wrote:
> I want to use this feature without appliation internal knowledge easily. 
> Maybe it can be useless without appliation behavior knowledge.
> But it will help various application experiments without much knowledge of application and recompile. 
> 
> ex) echo 'pid 0x8050000 0x100000' > sysfs or procfs or cgroup. 

Yes, this is common request.  Izik made some changes to enable a pid
based registration, just not been cleaned up and made available yet.

thanks,
-chris
