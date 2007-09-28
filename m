Return-Path: <linux-kernel-owner+w=401wt.eu-S1759102AbXI1Oyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759102AbXI1Oyx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 10:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753607AbXI1Oyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 10:54:44 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:36240 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453AbXI1Oyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 10:54:43 -0400
Subject: Re: kernel Oops in ext3 code
From: Badari Pulavarty <pbadari@gmail.com>
To: Norbert Preining <preining@logic.at>
Cc: Mingming Cao <cmm@us.ibm.com>, ext4 <linux-ext4@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070928045456.GM23215@gamma.logic.tuwien.ac.at>
References: <20070927103122.GB27783@gamma.logic.tuwien.ac.at>
	 <1190927903.3872.12.camel@localhost.localdomain>
	 <20070928045456.GM23215@gamma.logic.tuwien.ac.at>
Content-Type: text/plain
Date: Fri, 28 Sep 2007 07:57:43 -0700
Message-Id: <1190991464.10145.0.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-28 at 06:54 +0200, Norbert Preining wrote:
> Hi Mingming,
> 
> On Do, 27 Sep 2007, Mingming Cao wrote:
> > Could you please sent the objdump of the ext4_discard_reservation
> > function? It doesn't match what I see here.
> 
> I assume you meant ext3_.... I made
> 	objdump -x -D -s super.o
> (the only place where I found this function in the source code). If you
> want something else, let me know, but a bit more specific. Can I do the
> objdump directly from the kernel image file?
> 

objdump -DlS balloc.o 

would give us ext3_discard_reservation()

Thanks,
Badari

