Return-Path: <linux-kernel-owner+w=401wt.eu-S934390AbXEMQSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934390AbXEMQSy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 12:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758478AbXEMQSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 12:18:45 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:34222 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755771AbXEMQSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 12:18:44 -0400
Subject: Re: why does x86 "make defconfig" build a single, lonely module?
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Dave Jones <davej@redhat.com>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org
In-Reply-To: <1179072655.3723.42.camel@mulgrave.il.steeleye.com>
References: <Pine.LNX.4.64.0705131106160.3197@localhost.localdomain>
	 <20070513160608.GA29024@redhat.com>
	 <1179072655.3723.42.camel@mulgrave.il.steeleye.com>
Content-Type: text/plain
Date: Sun, 13 May 2007 11:18:35 -0500
Message-Id: <1179073116.3723.45.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-05-13 at 11:10 -0500, James Bottomley wrote:
> > -	depends on SCSI
> > +	depends on SCSI_SCAN_ASYNC
> 
> No.  SCSI_SCAN_ASYNC is a bool ... if you depend on it, you'll force the
> wait scan to be built in, which isn't the idea at all.

Plus SCSI_SCAN_ASYNC only sets the *default* for async scanning.  You
can alter this at boot time, so you could need the wait scan module even
with it set to N.

James


