Return-Path: <linux-kernel-owner+w=401wt.eu-S1761415AbZEAPJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761415AbZEAPJW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 11:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754771AbZEAPJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 11:09:09 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:33031 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253AbZEAPJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 11:09:08 -0400
Date: Fri, 1 May 2009 17:11:18 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Tim Abbott <tabbott@MIT.EDU>
Cc: David Howells <dhowells@redhat.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>
Subject: Re: [PATCH 5/6] mn10300: use new macros for .data.init_task.
Message-ID: <20090501151118.GA25659@uranus.ravnborg.org>
References: <1241135661-9147-6-git-send-email-tabbott@mit.edu> <1241135661-9147-1-git-send-email-tabbott@mit.edu> <1241135661-9147-2-git-send-email-tabbott@mit.edu> <1241135661-9147-3-git-send-email-tabbott@mit.edu> <1241135661-9147-4-git-send-email-tabbott@mit.edu> <1241135661-9147-5-git-send-email-tabbott@mit.edu> <11779.1241189179@redhat.com> <alpine.DEB.1.10.0905011048420.10966@vinegar-pot.mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0905011048420.10966@vinegar-pot.mit.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 11:00:12AM -0400, Tim Abbott wrote:
> On Fri, 1 May 2009, David Howells wrote:
> 
> > Tim Abbott <tabbott@MIT.EDU> wrote:
> > 
> > > .data.init_task should not need a separate output section; this change
> > > moves it into the .data section.
> > 
> > Hmmm...  This causes the kernel I'm building to make an extra page of RAM into
> > dead space.
> 
> I would try reversing the order of the things inside the .data output 
> section, since the stuff after .data at the end of this patch series is 
> page-aligned, while the stuff before .data isn't.

I'm looking into creating a WRDATA macro like we have RODATA today.
If that flys then we will hide a lot in that section,
including the correct order.

But it will take a few hours before I'm ready.

	Sam
