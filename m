Return-Path: <linux-kernel-owner+w=401wt.eu-S1756706AbXI1U2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706AbXI1U2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 16:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751299AbXI1U2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 16:28:04 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:46397 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208AbXI1U2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 16:28:03 -0400
Date: Fri, 28 Sep 2007 22:27:59 +0200
To: Mingming Cao <cmm@us.ibm.com>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Badari Pulavarty <pbadari@gmail.com>, ext4 <linux-ext4@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: kernel Oops in ext3 code
Message-ID: <20070928202759.GH16498@gamma.logic.tuwien.ac.at>
References: <1190991464.10145.0.camel@dyn9047017100.beaverton.ibm.com> <20070928150031.GF27873@gamma.logic.tuwien.ac.at> <1191002449.3815.9.camel@localhost.localdomain> <46FD4EE3.8030705@linux.vnet.ibm.com> <20070927103122.GB27783@gamma.logic.tuwien.ac.at> <1190927903.3872.12.camel@localhost.localdomain> <20070928045456.GM23215@gamma.logic.tuwien.ac.at> <1190991464.10145.0.camel@dyn9047017100.beaverton.ibm.com> <20070928150031.GF27873@gamma.logic.tuwien.ac.at> <1191002449.3815.9.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46FD4EE3.8030705@linux.vnet.ibm.com> <1191002449.3815.9.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On Fr, 28 Sep 2007, Mingming Cao wrote:
> i_block_alloc_info, it should be 0x14(20 bytes)...Are you running a
> vanilla 2.6.23-rc6?

Well yes, I add one patch for reducing the usb device resetting time,
but this was definitely not the problem, no usb device was attached.

> from the cache, so racing is not a issue there. Possible random memory
> corruption?

Could be could be. I would say since it is such a strange thing and
nobody has an idea we leave it for now, random memory corruption sounds
nice. If it occurs I can come back.


Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
in the space-time continuum.'
is he? Is he?'
                 --- Arthur failing in his first lesson of galactic physics
                 --- in four years.
                 --- Douglas Adams, The Hitchhikers Guide to the Galaxy
