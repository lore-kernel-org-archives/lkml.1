Return-Path: <linux-kernel-owner+w=401wt.eu-S1755494AbXFNRt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbXFNRt4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 13:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751036AbXFNRts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 13:49:48 -0400
Received: from smtp131.iad.emailsrvr.com ([207.97.245.131]:54304 "EHLO
	smtp131.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbXFNRtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 13:49:47 -0400
Message-ID: <46717F7E.2040507@gentoo.org>
Date: Thu, 14 Jun 2007 13:48:46 -0400
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Chuck Ebbert <cebbert@redhat.com>, linux-stable <stable@kernel.org>,
       Dave Jones <davej@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [stable]  libata spindown patches for 2.6.21-stable
References: <4671664A.8010404@redhat.com> <20070614173051.GA9039@kroah.com>
In-Reply-To: <20070614173051.GA9039@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> I think it looks way too big.

Agreed (otherwise I would have submitted the patches already).

> If there are smaller patches, it might be a bit more reasonable.

It may be possible to get rid of the couple of unrelated ones (sd 
printing, SCSI constants). These were required for the real patches to 
be able to build, but it would probably be easy to modify the real 
patches to build against kernels without those otherwise unrelated patches.

> Are there reported bugs that this patchset fixes?

Yes, but they are not regressions - libata has never done this right 
until now.

Here are a few:
https://bugs.gentoo.org/show_bug.cgi?id=174373
http://bugzilla.kernel.org/show_bug.cgi?id=7674
http://bugzilla.kernel.org/show_bug.cgi?id=7838
https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.17/+bug/67810

Daniel

