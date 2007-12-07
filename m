Return-Path: <linux-kernel-owner+w=401wt.eu-S1754252AbXLGDWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252AbXLGDWh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 22:22:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752975AbXLGDW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 22:22:27 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:65501 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbXLGDW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 22:22:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=C83U3yJBmOxkxgd2MLHcTbsW0CQtildHngqQf02KKiiUfKVD8sB/FHjJtoTQ0jih/S999bWB7Jw2Oh6gp+ktmJcOx0eLbkESoIEJLYvlrpIqgHc0Lp8nNsyAOCJfSnx63OW8jiTN374ZDSrrOJcE/eB1QogH+WkwCQykGqcSYY8=
Message-ID: <6934efce0712061922j682cee55pc1d5d079465f4849@mail.gmail.com>
Date: Thu, 6 Dec 2007 19:22:25 -0800
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Rob Landley" <rob@landley.net>
Subject: Re: [patch] ext2: xip check fix
Cc: carsteno@de.ibm.com, "Nick Piggin" <npiggin@suse.de>,
       "Christian Borntraeger" <borntraeger@de.ibm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Jens Axboe" <axboe@kernel.dk>
In-Reply-To: <200712061211.49443.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071204042628.GA26636@wotan.suse.de>
	 <20071206101848.GC25202@wotan.suse.de> <4757CDD4.5090606@de.ibm.com>
	 <200712061211.49443.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I have'nt looked at it yet. I do appreciate it, I think it might
> > broaden the user-base of this feature which is up to now s390 only due
> > to the fact that the flash memory extensions have not been implemented
> > (yet?). And it enables testing xip on other platforms. The patch is on
> > my must-read list.
>
> query: which feature is currently s390 only?  (Execute In Place?)

I think so.  The filemap_xip.c functionality doesn't work for Flash
memory yet.  Flash memory doesn't have struct pages to back it up with
which this stuff depends on.
