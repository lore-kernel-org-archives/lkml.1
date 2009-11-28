Return-Path: <linux-kernel-owner+w=401wt.eu-S1753637AbZK1Kgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637AbZK1Kgm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 05:36:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbZK1Kgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 05:36:42 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:55694 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbZK1Kgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 05:36:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=R0O0XR4fWCLKGnN3wILJiYmRRhg4DLD6RdDAiOR/23y1+bNvykYZfOGiZaxRJpZXcb
         L2dhvsT+TKPBWUi1H9arQ/7hTJufGYc9yGGKLUNOVmi2UojUXsiZ3SfJc4WF1gtKDQuZ
         VSuHKkwUVqWipbmY5UjGust4F0mRDMmqN9hqQ=
Subject: Re: XD/smartmedia - how to implement it right?
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, arnd@arndb.de,
       tglx@linutonix.de
In-Reply-To: <716701.11435.qm@web37602.mail.mud.yahoo.com>
References: <716701.11435.qm@web37602.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 28 Nov 2009 12:36:39 +0200
Message-ID: <1259404599.15208.6.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-27 at 23:22 -0800, Alex Dubov wrote: 
> > 
> > The "mtd uses blocking calls" argument I can help
> > with.  For some other
> > project I've added non-blocking calls to mtd[1].
> > 
> > Biggest problems I see are a) the userspace interface and
> > b) allowing
> > both raw flash access through MTD and block device access
> > with an FTL.
> > 
> > [1] http://lists.infradead.org/pipermail/linux-mtd/2009-November/028065.html
> > 
> > Jörn
> 
> I actually tried several approaches to this problem and I think, I have a good idea about how to create a fully asynchronous mtd driver, which can handle different device models. Unfortunately, I had other commitments so I couldn't advance my mtd stuff.
> 
> Recently I was going to go back to it, but then I was asked to implement some additional functionality in rapidio subsystem, which I'll have to take care of first.

Hi, 

First of all, thank you very much for your contributions.
Could you explain, why we need an asynchronous mtd driver?

Also, as I understand the command interface more and more, it seems that
'magically' xD card had same interface as standard NAND flash chip.

I think I can implement the driver for each controller just like an nand
chip driver.

Best regards,
Maxim Levitsky



