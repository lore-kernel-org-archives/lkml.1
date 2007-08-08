Return-Path: <linux-kernel-owner+w=401wt.eu-S1755821AbXHHKoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821AbXHHKoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 06:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751083AbXHHKoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 06:44:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54223 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbXHHKoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 06:44:07 -0400
Date: Wed, 8 Aug 2007 12:43:09 +0200
From: Karel Zak <kzak@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Diego Calleja <diegocg@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
Message-ID: <20070808104309.GA3173@petra.dvoda.cz>
References: <20070803123712.987126000@chello.nl> <alpine.LFD.0.999.0708031518440.8184@woody.linux-foundation.org> <20070804063217.GA25069@elte.hu> <20070804070737.GA940@elte.hu> <20070804103347.GA1956@elte.hu> <alpine.LFD.0.999.0708040915360.5037@woody.linux-foundation.org> <20070804163733.GA31001@elte.hu> <20070804190210.8b1530dd.diegocg@gmail.com> <20070804171724.GA4740@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070804171724.GA4740@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 04, 2007 at 07:17:24PM +0200, Ingo Molnar wrote:
> 
> * Diego Calleja <diegocg@gmail.com> wrote:
> 
> > El Sat, 4 Aug 2007 18:37:33 +0200, Ingo Molnar <mingo@elte.hu> escribió:
> > 
> > > thousands of applications. So for most file workloads we give 
> > > Windows a 20%-30% performance edge, for almost nothing. (for 
> > > RAM-starved kernel builds the performance difference between atime 
> > > and noatime+nodiratime setups is more on the order of 40%)
> > 
> > Just curious - do you have numbers with relatime?
> 
> nope. Stupid question, i just tried it and got this:
> 
>  EXT3-fs: Unrecognized mount option "relatime" or missing value
> 
> i've got util-linux-2.13-0.46.fc6 and 2.6.22 on that box, shouldnt that 

 The relatime patch has been applied to util-lilnux-ng-2.13 (now -rc3),
 you will see it in Fedora 8 (and probably in the others distros).

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
