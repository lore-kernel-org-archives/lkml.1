Return-Path: <linux-kernel-owner+w=401wt.eu-S1761853AbYBFKWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761853AbYBFKWR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 05:22:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759207AbYBFKWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 05:22:06 -0500
Received: from wx-out-0506.google.com ([66.249.82.234]:43163 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758273AbYBFKWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 05:22:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sBREfVl7g81WDz9eEOtLqmWFlLNIcVv2+4r0/G8ugYYTS9rJyenFNdeek1e++EM9TRKDW8y1MLsqB0HuMMnFrJw2sUZ/8mhZJELET3c2gpRAdVEa3YgYG/BAUqmOjDtV3557+8cp8xPLsSJ9nCBAThgkfq7v/tmNHsu5JVR5uhg=
Message-ID: <e2e108260802060222p294abff9kde72bbb04a115752@mail.gmail.com>
Date: Wed, 6 Feb 2008 11:22:00 +0100
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       "Vladislav Bolkhovitin" <vst@vlnb.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>,
       linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Mike Christie" <michaelc@cs.wisc.edu>
In-Reply-To: <47A8A1C8.2010407@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47A05CBD.5050803@vlnb.net>
	 <1202145901.3096.49.camel@localhost.localdomain>
	 <alpine.LFD.1.00.0802041018390.3034@hp.linux-foundation.org>
	 <1202151989.11265.576.camel@haakon2.linux-iscsi.org>
	 <alpine.LFD.1.00.0802041130140.3034@hp.linux-foundation.org>
	 <20080204210121.GF18682@fieldses.org>
	 <alpine.LFD.1.00.0802041317280.3034@hp.linux-foundation.org>
	 <47A7986B.1070206@garzik.org>
	 <e2e108260802050038v6648495ap13cf799727c00cfc@mail.gmail.com>
	 <47A8A1C8.2010407@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 5, 2008 6:50 PM, Jeff Garzik <jeff@garzik.org> wrote:
> For remotely accessing data, iSCSI+fs is quite simply more overhead than
> a networked fs.  With iSCSI you are doing
>
>         local VFS -> local blkdev -> network
>
> whereas a networked filesystem is
>
>         local VFS -> network

There are use cases than can be solved better via iSCSI and a
filesystem than via a network filesystem. One such use case is when
deploying a virtual machine whose data is stored on a network server:
in that case there is only one user of the data (so there are no
locking issues) and filesystem and block device each run in another
operating system: the filesystem runs inside the virtual machine and
iSCSI either runs in the hypervisor or in the native OS.

Bart Van Assche.
