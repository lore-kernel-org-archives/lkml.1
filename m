Return-Path: <linux-kernel-owner+w=401wt.eu-S1030721AbXCSWHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030721AbXCSWHG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 18:07:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030726AbXCSWHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 18:07:04 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:38272 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030721AbXCSWHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 18:07:00 -0400
Subject: Re: 2.6.20.3: kernel BUG at mm/slab.c:597 try#2
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>,
       Andreas Steinmetz <ast@domdv.de>, linux-scsi@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <200703191747.48826.gene.heskett@gmail.com>
References: <45FDDA8E.8030100@domdv.de> <45FECD45.20705@cs.wisc.edu>
	 <1174328987.3512.37.camel@mulgrave.il.steeleye.com>
	 <200703191747.48826.gene.heskett@gmail.com>
Content-Type: text/plain
Date: Mon, 19 Mar 2007 17:06:57 -0500
Message-Id: <1174342017.3512.58.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-19 at 17:47 -0400, Gene Heskett wrote:
> James, could this also be the cause of a tar based backup going crazy and 
> thinking all data is new under any 2.6.21-rc* kernel I've tested so far 
> with amanda, which in my case uses tar?  I've tried the fedora patched 
> tar-1.15-1, and one I hand built right after 1.15-1 came out over a year 
> ago, and they both do it, but only when booted to a 2.6.21-rc* kernel.
> 
> This obviously will be a show-stopper, either for amanda (and by 
> inference, any app that uses tar), or for the migration of an amanda 
> users machinery to a 2.6.21 kernel.

Er, I don't think so .. that sounds like mtime miscompare, which is
either a problem with the filesystem or a problem with the way mtime is
stored in the tar archive.

James


