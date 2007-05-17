Return-Path: <linux-kernel-owner+w=401wt.eu-S1760068AbXEQDkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760068AbXEQDkA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 23:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754576AbXEQDjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 23:39:53 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:52591 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754124AbXEQDjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 23:39:52 -0400
X-Sasl-enc: krC/1qLOTQjV+ZNhlQH1D27BkJEkBbEKPLHqeOEfrwPo 1179373192
Date: Thu, 17 May 2007 00:39:47 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Rob Landley <rob@landley.net>
Cc: Tejun Heo <htejun@gmail.com>, Dave Jones <davej@redhat.com>,
       Francesco Pretto <ceztko@gmail.com>, Phillip Susi <psusi@cfl.rr.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Weird hard disk noise on shutdown (bug #7674)
Message-ID: <20070517033947.GA24757@khazad-dum.debian.net>
References: <fa.Ia7dfo7Zd5kB6KhSYisfswa1aj4@ifi.uio.no> <200705161948.56497.rob@landley.net> <20070517005842.GC600@khazad-dum.debian.net> <200705162305.11755.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705162305.11755.rob@landley.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2007, Rob Landley wrote:
> > But you need to detect if the kernel has proper SCSI device shutdown
> > support, because if it does not, you have to do a cache flush and spindown
> > on shutdown(8) if you can...
> 
> Or (and this is just a thought), you could upgrade your kernel so it correctly 
> handles your hardware, treating this just like any other driver bug or other 

The distros can't update kernels that easily on their stable branches.

And in the userland side, we are not breaking things any further for users
of kernels before 2.6.22 anyway.  Don't expect shutdown(8) to remove support
for <2.6.22 any time soon, at least in Debian.  That will happen only when
we are forced by some other reason to completely break compatibility with
such kernels.

> Last I checked you didn't have to spin down a USB flash key.  If SATA is 

But you have to spin down an USB HD...  el-cheapo USB enclosures will NOT do
it for you.  It is not an easy problem.

> SCSI, what the heck is SAS?  (Answer: a cynical marketing hack to bleed SCSI 
> bigots for the huge margins they've always been bled for.  But oh well.)  It 

Actually, in my limited experience, SAS is marginally less crappy than SATA,
and has a higher MTBF, probably because the manufacturers try to cut less
corners.  But if one can get high-quality SATA drives (where?!), I don't
know why SAS would be superior to SATA.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
