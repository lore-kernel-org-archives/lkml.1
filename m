Return-Path: <linux-kernel-owner+w=401wt.eu-S1752820AbXDAEN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752820AbXDAEN5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 00:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbXDAEN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 00:13:57 -0400
Received: from smtp113.sbc.mail.mud.yahoo.com ([68.142.198.212]:35858 "HELO
	smtp113.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752820AbXDAENz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 00:13:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=nbQ3EDYaLCz+H0Beu6K1GHSO5Vo+VfTtUXLAOXOXT/Vk590KZmw8zm0fDmeyA1XsHyRsZ4TRIHz/Rh7w3370ywxeD0/0k4jtRh2uDSPRLn8QuIOWYbvmr9+Idab6GmEjJLj5imTiqqt8b1BgiYVNu07yZZPqPiNPqAKUmPr4Oxs=  ;
X-YMail-OSG: XIp54b0VM1lPxxq5_Uucbnxjt2W5.wdjEk_muDfOEykQOY5jKj8j.DIFs4063nB_XXiAho0UUKCADpdcfgtjzPT6ClqS9CJm1MkIB1KBjnFz1iQ0KpyGiYiyhRpXx4YI9yDfBIkzmxMAJg--
From: David Brownell <david-b@pacbell.net>
To: "Jeff Chua" <jeff.chua.linux@gmail.com>
Subject: Re: [linux-pm] [PATCH v2] Add suspend/resume for HPET
Date: Sat, 31 Mar 2007 21:13:51 -0700
User-Agent: KMail/1.7.1
Cc: linux-pm@lists.linux-foundation.org, "Adrian Bunk" <bunk@stusta.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, gregkh@suse.de,
       "Ingo Molnar" <mingo@elte.hu>, "Jens Axboe" <jens.axboe@oracle.com>,
       jgarzik@pobox.com, "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-acpi@vger.kernel.org, linux-ide@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-pci@atrey.karlin.mff.cuni.cz,
       "Maxim Levitsky" <maximlevitsky@gmail.com>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       "Sergei Shtylyov" <sshtylyov@ru.mvista.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <200703311232.57505.david-b@pacbell.net> <b6a2187b0703312013o6c305e00v829894f215812550@mail.gmail.com>
In-Reply-To: <b6a2187b0703312013o6c305e00v829894f215812550@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703312113.52789.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 31 March 2007 8:13 pm, Jeff Chua wrote:
> On 4/1/07, David Brownell <david-b@pacbell.net> wrote:
> > for those will all get grouped together ... suspended "very late" and
> > resumed "very early", regardless of when they get registered.  Pretty
> > much the driver model parts of what Linus was suggesting; clockevent
> > bits would still be needed.
> 
> I tested your patch with CONFIG_NO_HZ=y, but it still hangs while
> suspending to disk (before the percent saving).

Of course.  No clockevent updates...

