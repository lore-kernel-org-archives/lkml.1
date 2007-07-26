Return-Path: <linux-kernel-owner+w=401wt.eu-S936026AbXGZSGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936026AbXGZSGP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 14:06:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935854AbXGZSFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 14:05:38 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:40437 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S936126AbXGZSFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 14:05:36 -0400
Subject: Re: [PATCH v2] Remove libsas PCI dependencies
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Meelis Roos <mroos@linux.ee>, linux-scsi <linux-scsi@vger.kernel.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       "Darrick J. Wong" <djwong@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <46A8DE10.8030108@garzik.org>
References: <Pine.SOC.4.64.0707261129220.17385@math.ut.ee>
	 <46A867AB.7050007@garzik.org>
	 <1185454007.3501.34.camel@localhost.localdomain>
	 <46A8A185.7010609@garzik.org> <Pine.SOC.4.64.0707262030090.1921@math.ut.ee>
	 <46A8DE10.8030108@garzik.org>
Content-Type: text/plain
Date: Thu, 26 Jul 2007 14:05:34 -0400
Message-Id: <1185473134.3501.70.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-26 at 13:46 -0400, Jeff Garzik wrote:
> Meelis Roos wrote:
> >> Eliminate unnecessary PCI dependencies in libsas.  It should use generic DMA
> >> and struct device like other subsystems.
> > 
> > Compiles fine, unfortunately I can not test kernels on this machine 
> > since I have yet to dig out the reason my kernels do not boot.
> 
> That's about the best we can ask for :)  Thanks.  I'm pretty sure you do 
> not have any SAS hardware in your sparc32...

I've tested it on aic94xx.

James


