Return-Path: <linux-kernel-owner+w=401wt.eu-S1756254AbXKKANe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254AbXKKANe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 19:13:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755598AbXKKAN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 19:13:26 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48860 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755433AbXKKANY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 19:13:24 -0500
Date: Sat, 10 Nov 2007 16:13:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Will Trives <will@trivescon.com.au>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-acpi@vger.kernel.org
Subject: Re: cd/dvd inaccessible in 2.6.24-rc2
Message-Id: <20071110161301.4d50676f.akpm@linux-foundation.org>
In-Reply-To: <20071110230553.1a935ec6@the-village.bc.nu>
References: <1194668831.3436.14.camel@Athas>
	<20071110144923.beb7bbae.akpm@linux-foundation.org>
	<20071110230553.1a935ec6@the-village.bc.nu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Nov 2007 23:05:53 +0000 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > > ata9.00: qc timeout (cmd 0xa0)
> > > ata9.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> > > ata9.00: cmd a0/00:00:00:02:00/00:00:00:00:00/a0 tag 0 cdb 0x5a data 2
> > > in
> > >          res 51/54:03:00:02:00/00:00:00:00:00/a0 Emask 0x5 (timeout)
> > > ata9.00: status: { DRDY ERR }
> 
> Could be an IRQ/ACPI regression, and in fact to me it looks more like
> that, than an IDE one.

Drat.  Seems that once we break that sort of thing we never fix it again.

> Probably worth trying the various IRQ routing
> options and seeing if they help.

Yup.

Please, if you have time, bisect it down to the offending commit?

There's info at http://www.kernel.org/doc/local/git-quick.html which should
help.

Thanks.
