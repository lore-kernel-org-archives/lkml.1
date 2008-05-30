Return-Path: <linux-kernel-owner+w=401wt.eu-S1756987AbYE3KjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756987AbYE3KjJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 06:39:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbYE3Ki4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 06:38:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55974 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119AbYE3Kiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 06:38:55 -0400
Subject: Re: [Ksummit-2008-discuss] RFC: Moving firmware blobs out of the
	kernel.
From: David Woodhouse <dwmw2@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Matthew Wilcox <matthew@wil.cx>,
       Arjan van de Ven <arjan@linux.intel.com>,
       James.Bottomley@hansenpartnership.com,
       ksummit-2008-discuss@lists.linux-foundation.org,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
In-Reply-To: <20080530102008.6645a0ad@core>
References: <1211995212.3445.52.camel@localhost.localdomain>
	 <20080528.225826.40264516.davem@davemloft.net>
	 <1212041839.8888.38.camel@pasglop> <20080529124548.GC8065@mit.edu>
	 <1212077700.26088.83.camel@shinybook.infradead.org>
	 <20080529164745.GA21763@kroah.com> <483F1232.4010003@linux.intel.com>
	 <20080529204736.GZ22636@parisc-linux.org>
	 <86802c440805291355p5697c775k5f0beb8163688058@mail.gmail.com>
	 <20080529210304.GA8866@kroah.com>  <20080530102008.6645a0ad@core>
Content-Type: text/plain
Date: Fri, 30 May 2008 13:38:38 +0300
Message-Id: <1212143919.29244.9.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-30 at 10:20 +0100, Alan Cox wrote:
> > Not all firmware has the ability to check the version :(
> > 
> > So while Arjan's goal would be nice, Matthew is right, this can't happen
> > for all types of firmware.
> 
> Well for loaded or packaged firmware it can happen. Just stick a revision
> number on the start of the firmware file and check it rather than load it
> into the hardware in that specific driver.

Or append it to the name of the firmware file, in some cases.

-- 
dwmw2

