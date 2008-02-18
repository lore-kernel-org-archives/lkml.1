Return-Path: <linux-kernel-owner+w=401wt.eu-S1759251AbYBRMFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759251AbYBRMFe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 07:05:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758052AbYBRMF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 07:05:26 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:39517 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757877AbYBRMF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 07:05:26 -0500
To: peterz@infradead.org
CC: miklos@szeredi.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       auke-jan.h.kok@intel.com
In-reply-to: <1203079537.6855.41.camel@twins> (message from Peter Zijlstra on
	Fri, 15 Feb 2008 13:45:37 +0100)
Subject: Re: 2.6.24-mm1 bugs
References: <E1JPyyn-00055D-2i@pomaz-ex.szeredi.hu> <1203079537.6855.41.camel@twins>
Message-Id: <E1JR4kJ-0003BE-Ee@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 18 Feb 2008 13:05:19 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  - strange key repeating (short press of a key results in lots of key
> >    press events) when there's some sort of load (I/O?)  I may have
> >    seen this on non-mm kernels as well, but it's definitely more
> >    noticable in -mm
> 
> Do you have CONFIG_FAIR_GROUP_SCHED enabled?, if so, does disabling it
> make it go away?

I haven't experienced this since disabling CONFIG_FAIR_GROUP_SCHED.
What's more, the network problems have also gone away.

Since I haven't done extensive testing, this may just be coincidence.
Let me know if you need more info.

Thanks,
Miklos
