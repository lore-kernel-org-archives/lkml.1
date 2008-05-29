Return-Path: <linux-kernel-owner+w=401wt.eu-S1759460AbYE2VGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759460AbYE2VGW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 17:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbYE2VGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 17:06:12 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39325 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbYE2VGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 17:06:11 -0400
Date: Thu, 29 May 2008 14:03:04 -0700
From: Greg KH <greg@kroah.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Arjan van de Ven <arjan@linux.intel.com>,
       James.Bottomley@hansenpartnership.com,
       ksummit-2008-discuss@lists.linux-foundation.org,
       David Woodhouse <dwmw2@infradead.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [Ksummit-2008-discuss] RFC: Moving firmware blobs out of the
	kernel.
Message-ID: <20080529210304.GA8866@kroah.com>
References: <1211995212.3445.52.camel@localhost.localdomain> <20080528.225826.40264516.davem@davemloft.net> <1212041839.8888.38.camel@pasglop> <20080529124548.GC8065@mit.edu> <1212077700.26088.83.camel@shinybook.infradead.org> <20080529164745.GA21763@kroah.com> <483F1232.4010003@linux.intel.com> <20080529204736.GZ22636@parisc-linux.org> <86802c440805291355p5697c775k5f0beb8163688058@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440805291355p5697c775k5f0beb8163688058@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 01:55:16PM -0700, Yinghai Lu wrote:
> On Thu, May 29, 2008 at 1:47 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> > On Thu, May 29, 2008 at 01:29:38PM -0700, Arjan van de Ven wrote:
> >> I very much would like to see a kernel-firmware or something tarbal that contains
> >> a copy of all relevant "freely distributable" firmware, that users can just install
> >> independent of the actual kernel version (and that kbuild would just pick up somehow).
> >> That way we can deal with a lot more firmware without having to pollute the kernel / kernel release process
> >> (after all, the timing is different in terms of releasing) while making it easy
> >> to get the lot of it.
> >
> > There's definitely two schools of thought on this.  Sometimes firmware
> > changes (or adds) an interface.  If the kernel driver has to accommodate
> > new and old firmware, that adds complexity, and we all know that added
> > complexity means more bugs.  So I can definitely see some vendors
> > wanting to distribute their firmware with the kernel.
> >
> driver should check fw version...

Not all firmware has the ability to check the version :(

So while Arjan's goal would be nice, Matthew is right, this can't happen
for all types of firmware.

thanks,

greg k-h
