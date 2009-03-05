Return-Path: <linux-kernel-owner+w=401wt.eu-S1755309AbZCEOt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbZCEOt7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 09:49:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753869AbZCEOtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 09:49:45 -0500
Received: from smtp.nokia.com ([192.100.122.230]:52193 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbZCEOto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 09:49:44 -0500
Subject: Re: [PATCH 1/3] [MTD] Flex-OneNAND support
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Rohit Hagargundgi <h.rohit@samsung.com>,
       David Woodhouse <dwmw2@infradead.org>,
       "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <49AFD5EA.5010502@nokia.com>
References: <20090303063605.GA30258@july>
	 <20090303124948.dda294e5.akpm@linux-foundation.org>
	 <49AE6907.1080702@nokia.com>
	 <20090304085055.c9de6cbb.akpm@linux-foundation.org>
	 <49AFD5EA.5010502@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Mar 2009 16:46:58 +0200
Message-Id: <1236264418.4261.91.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 05 Mar 2009 14:47:09.0453 (UTC) FILETIME=[42E773D0:01C99DA1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-05 at 15:38 +0200, Adrian Hunter wrote:
> > My point is: for what purpose was EUNCLEAN created by whoever created
> > it and, given that, is its use by MTD appropriate?  Because it does
> > appear that this gets returned all the way to userspace sometimes.
> 
> I have had a look at the use of EUCLEAN and found the following:
> 	1. It does not seem to be defined in POSIX
> 	2. It may have been used by unix variants to indicate an
> attempt to mount a file system whose superblock was not marked
> as clean.
> 	3. In Linux, it is used almost exclusively by MTD, with
> one exception in smbfs, from which it is tempting to conclude that
> smbfs (at least) is using it incorrectly.  There is one web page
> http://www.wlug.org.nz/EUCLEAN where the author suggests ENOMEDIUM
> might be a better choice.
> 
> Can you point me to where EUCLEAN is returned to userspace?  I took
> a quick look and couldn't see it.

But for us, EUCLEAN looks like a good name :-) Probably this is why
tglx choose this error code.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

