Return-Path: <linux-kernel-owner+w=401wt.eu-S1758834AbXJ2PSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758834AbXJ2PSd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 11:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752386AbXJ2PSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 11:18:25 -0400
Received: from mail.gmx.net ([213.165.64.20]:38067 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751863AbXJ2PSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 11:18:24 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18LnnNDNUMLyuzJ8zjb01QyyBL2zsZHINGKCRM6Yo
	6fLykhfL90Oblb
Subject: Re: [Linux-NTFS-Dev] 2.6.23 regression: second access of empty
	ntfs file leads to D	state hang
From: Mike Galbraith <efault@gmx.de>
To: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ntfs-dev@lists.sourceforge.net
In-Reply-To: <1193668997.7284.2.camel@Homer.simpson.net>
References: <1193638086.7409.21.camel@Homer.simpson.net>
	 <E3E758D0-25AC-45B8-9BAB-F8CDF75AF3CA@cam.ac.uk>
	 <1193658311.7324.2.camel@Homer.simpson.net>
	 <4E61D235-B8E8-43DF-96A5-B3169E6AB223@cam.ac.uk>
	 <1193668997.7284.2.camel@Homer.simpson.net>
Content-Type: text/plain
Date: Mon, 29 Oct 2007 16:18:19 +0100
Message-Id: <1193671099.7172.0.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-29 at 15:43 +0100, Mike Galbraith wrote:
> On Mon, 2007-10-29 at 13:39 +0000, Anton Altaparmakov wrote:
> > Hi Mike,
> > 
> > Thanks for the files.  That is really odd.  And you are sure this just  
> > works with 2.6.22.10 on the exact same file?  Have you run  "chkdsk / 
> > f /v /x" on the NTFS volume from Windows?
> 
> Yes, 2.6.22.10 can md5sum that file just fine, did it several times.  I
> haven't run chkdsk.

I now have fun chkdsk, it didn't gripe, and the error is still present.

	-Mike

