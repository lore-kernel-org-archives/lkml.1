Return-Path: <linux-kernel-owner+w=401wt.eu-S1752947AbZLAQlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947AbZLAQlv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 11:41:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbZLAQlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 11:41:51 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:57430 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbZLAQlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 11:41:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=EaTzhdk8FhPRYQ9Lx7wYye8v9XdScWi50i4BNWMCwqWCK2uesvwpAsfZXG3E8gBFi9
         L7OSyE6db00pJgAv9NCa5URYdDRS9fa2u5uxiQ3ydydXIA4hPYKbtG+0nce5ZU6NAhlm
         byDfwcZlYqDmEI9QCqMczy+c/7b1wpzvOpqbQ=
Subject: Re: XD/smartmedia - how to implement it right?
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, arnd <arnd@arndb.de>
In-Reply-To: <621988.63882.qm@web37601.mail.mud.yahoo.com>
References: <621988.63882.qm@web37601.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Dec 2009 18:41:51 +0200
Message-ID: <1259685711.18599.22.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-01 at 08:10 -0800, Alex Dubov wrote: 
> 
> --- On Tue, 12/1/09, Jörn Engel <joern@logfs.org> wrote:
> 
> > From: Jörn Engel <joern@logfs.org>
> > Subject: Re: XD/smartmedia - how to implement it right?
> > To: "Maxim Levitsky" <maximlevitsky@gmail.com>
> > Cc: "Alex Dubov" <oakad@yahoo.com>, "linux-kernel" <linux-kernel@vger.kernel.org>, arnd@arndb.de, tglx@linutonix.de
> > Date: Tuesday, December 1, 2009, 12:22 AM
> > On Tue, 1 December 2009 01:04:26
> > +0200, Maxim Levitsky wrote:
> > > 
> > > Alex, could you do me a favor, and explain why partial
> > block writes
> > > don't work?
> > > What happens if its done?
> > 
> > With the Alauda and the limited set of cards I tried they
> > work.
> > 
> > Jörn
> > 
> 
> It's a bug particular to jmicron controllers.

Thanks!

So, I will write the driver for my controller using nand subsystem, and
then, I see what to do next.
If you write your mtd driver, I have no objection to port my driver to
yours (I assume that there will be a common core, just like the nand
subsystem, and small drivers.)


And the last question probably:

I know that xD is very similar to nand, but due to things like the
above, maybe full mtd driver is really better.
There will be some code duplication, but on the other hand the driver
could follow the way windows driver works more closely, thus making it
more compatable with xD cards.

So if I or Alex write the full blown mtd driver, there will be no
objections because of code duplication?


Anyway, now I am going to stop talking and start coding (I did quite in
depth review of mtd and nand systems already)


Best regards,
Maxim Levitsky

