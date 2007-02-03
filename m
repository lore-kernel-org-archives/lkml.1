Return-Path: <linux-kernel-owner+w=401wt.eu-S1946302AbXBCDOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946302AbXBCDOv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 22:14:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946303AbXBCDOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 22:14:51 -0500
Received: from hancock.steeleye.com ([71.30.118.248]:38504 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946302AbXBCDOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 22:14:50 -0500
Subject: Re: [PATCH 2.6.19.2] SCSI sd:  udev accessing an uninitialized
	scsi_disk results in a crash
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@osdl.org>,
       Nagendra Singh Tomar <nagendra_tomar@adaptec.com>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20070203015635.GA18467@kroah.com>
References: <200702021734.57161.nagendra_tomar@adaptec.com>
	 <20070202171924.a225cff7.akpm@linux-foundation.org>
	 <20070203015635.GA18467@kroah.com>
Content-Type: text/plain
Date: Fri, 02 Feb 2007 21:14:36 -0600
Message-Id: <1170472476.3380.55.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-02 at 17:56 -0800, Greg KH wrote:
> > Thanks - I'll queue this up for 2.6.20 also.
> 
> No objection from me, as long as James says this is ok.
> 
> I wonder why we haven't noticed this in the past?

Because the race is so small ...

I'll queue it in the rc-fixes tree .. I have three others for 2.6.20

James


