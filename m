Return-Path: <linux-kernel-owner+w=401wt.eu-S932431AbYEHXVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431AbYEHXVc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 19:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753983AbYEHXVD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 19:21:03 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49399 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473AbYEHXVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 19:21:01 -0400
Message-ID: <48238ADA.5060206@garzik.org>
Date: Thu, 08 May 2008 19:20:58 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?=22J=2EA=2E_Magall=F3n=22?= <jamagallon@ono.com>
CC: Linus-IDE <linux-ide@vger.kernel.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: The never enfind DRDY saga
References: <20080509005111.7cf55350@werewolf.home>
In-Reply-To: <20080509005111.7cf55350@werewolf.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J.A. Magallón wrote:
> Hi all...
> 
> I'm getting again my friendly DRDY errors, this time on the new disk I got
> to replace the old one (that fortunately was still under warranty...).
> This is a brand new disk, it came perfectly packaged...
> Now it is not a Seagate, but a WD:

Note that DRDY is not an error:

	http://ata.wiki.kernel.org/index.php/Libata_error_messages

But moreover, for Serial ATA, timeouts are generally due to platform 
problems, irq problems, or driver problems.  When we see timeouts, we 
generally do not look at the hard drive as the primary cause.

Have you gone through the debugging process for irq problems -- turning 
off ACPI, noapic, etc.?

	Jeff


