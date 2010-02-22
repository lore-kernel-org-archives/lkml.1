Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483Ab0BVWMf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 17:12:35 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:37943 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146Ab0BVWMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 17:12:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=BqUftV3tRdXP4ReXxxSCCarMGyKvpB0YpYvIs/2qcak+i4wXnaOe0OQJLPRU7AEvur
         Dd6MKLBfxb4NDgf7Nd3xl+pZbS9xNUXqJmZ6ie7SAcum5WnCvgSGFQfVsI8Kixx2Aibn
         8ra0ETkNOYnpLcCs+zmuf2X8MRM3zqm/t+m+E=
Subject: Re: [PATCH 13/15] MTD: add few workarounds to nand system for
 SmartMedia/xD chips.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: David Woodhouse <dwmw2@infradead.org>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Dubov <oakad@yahoo.com>, joern <joern@logfs.org>,
       stanley.miao@windriver.com, Vitaly Wool <vitalywool@gmail.com>
In-Reply-To: <alpine.LFD.2.00.1002222235560.4136@localhost.localdomain>
References: <1266863982-5258-1-git-send-email-maximlevitsky@gmail.com>
	 <1266863982-5258-14-git-send-email-maximlevitsky@gmail.com>
	 <alpine.LFD.2.00.1002222223090.4136@localhost.localdomain>
	 <1266874402.4971.9.camel@maxim-laptop>
	 <alpine.LFD.2.00.1002222235560.4136@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Feb 2010 00:12:29 +0200
Message-ID: <1266876749.4971.15.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-22 at 22:53 +0100, Thomas Gleixner wrote: 
> On Mon, 22 Feb 2010, Maxim Levitsky wrote:
> 
> > On Mon, 2010-02-22 at 22:25 +0100, Thomas Gleixner wrote: 
> > > On Mon, 22 Feb 2010, Maxim Levitsky wrote:
> > > 
> > > > * Add an option NAND_SMARTMEDIA that can be set by nand driver
> > > >  If set, it will cause separate ID table to be used, which includes
> > > >  mask rom devices and new xD cards
> > > 
> > > Why that option ? We can just extend the existing ids table and be
> > > done. No extra magic needed.
> > >  
> > 
> > Two reasons.
> > 
> > First of all several xD chips (I belive the Type M) have exactly same
> > IDs like normal nand chips. However they don't report capabilities about
> > pagesize, blocksize, etc.

Sure, I didn't meant the #WP line. Sure it is set by the controller.
I mean WP bit in status report.

Best regards,
Maxim Levitsky


