Return-Path: <linux-kernel-owner+w=401wt.eu-S1756024AbXJIVFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024AbXJIVFl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 17:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754711AbXJIVFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 17:05:33 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:39053 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754560AbXJIVFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 17:05:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=3ujcQvaqIIcCeXEt6H42DZ5ynYEq/CrnrUQYLMKCVhHQVtctb1lxjqTlyK0OpJIV+zG32o/jb+wb02rg7ziHjctUGR45hRuZAHEbAykcHNbHLzw5PmawFvlqz54gf4SXqyWXKWfLy+dJ76roQ2z9tC5kgY3tbxyeWFNd3FgfbcI=  ;
X-YMail-OSG: F9aLlkIVM1l.QORf9In9dtvJEYT0YigGcoPP8yYCnUynU4DF
Date: Tue, 09 Oct 2007 14:05:34 -0700
From: David Brownell <david-b@pacbell.net>
To: greg@kroah.com, davem@davemloft.net
Subject: Re: OHCI root_port_reset() deadly loop...
Cc: linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <20071009043643.773CC23715F@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
 <20071008.214408.98397070.davem@davemloft.net>
 <20071009163827.E7DB310B535@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
 <20071009.134116.63997473.davem@davemloft.net>
 <20071009204642.GA11575@kroah.com>
In-Reply-To: <20071009204642.GA11575@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071009210534.E918F236A37@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > > What values do you see for "portstat"?
> > > >
> > > > 0x111
> > > 
> > > That's unfortunately useless ... PPS, PRS, CCS (meaning powered,
> > > resetting, connected).  In short, there is *no* indication from
> > > the OHCI hardware that a disconnect happened.
> > 
> > But it's an excellent example of why my patch is mandatory.

I never disagreed that some patch for that issue was needed.


> I agree.  David Brownell, unless you strongly object, I'll take David
> Miller's patch and add it to my tree.
>
> And if you do object, can you respond to the objection with a version of
> the patch that you would accept?  :)

I'll send some version with a signoff.

- Dave

