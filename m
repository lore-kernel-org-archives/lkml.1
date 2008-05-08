Return-Path: <linux-kernel-owner+w=401wt.eu-S933982AbYEHXXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933982AbYEHXXe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 19:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753239AbYEHXXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 19:23:19 -0400
Received: from smtp.ono.com ([62.42.230.12]:14933 "EHLO resmaa02.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752626AbYEHXXR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 19:23:17 -0400
Date: Fri, 9 May 2008 01:23:09 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus-IDE <linux-ide@vger.kernel.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: The never enfind DRDY saga
Message-ID: <20080509012309.13666199@werewolf.home>
In-Reply-To: <48238ADA.5060206@garzik.org>
References: <20080509005111.7cf55350@werewolf.home>
	<48238ADA.5060206@garzik.org>
X-Mailer: Claws Mail 3.4.0cvs16 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 May 2008 19:20:58 -0400, Jeff Garzik <jeff@garzik.org> wrote:

> J.A. Magallón wrote:
> > Hi all...
> > 
> > I'm getting again my friendly DRDY errors, this time on the new disk I got
> > to replace the old one (that fortunately was still under warranty...).
> > This is a brand new disk, it came perfectly packaged...
> > Now it is not a Seagate, but a WD:
> 
> Note that DRDY is not an error:
> 
> 	http://ata.wiki.kernel.org/index.php/Libata_error_messages
> 
> But moreover, for Serial ATA, timeouts are generally due to platform 
> problems, irq problems, or driver problems.  When we see timeouts, we 
> generally do not look at the hard drive as the primary cause.
> 
> Have you gone through the debugging process for irq problems -- turning 
> off ACPI, noapic, etc.?
> 

Thanks, will look at that page and see if I can debug some more info.

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2008.1 (Cooker) for i586
Linux 2.6.23-jam05 (gcc 4.2.2 20071128 (4.2.2-2mdv2008.1)) SMP PREEMPT
