Return-Path: <linux-kernel-owner+w=401wt.eu-S1757382AbXJGWUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382AbXJGWUj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 18:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756102AbXJGWUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 18:20:30 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:43857 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756098AbXJGWU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 18:20:29 -0400
Message-ID: <47095BA3.2020705@garzik.org>
Date: Sun, 07 Oct 2007 18:20:19 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Tejun Heo <htejun@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: Bug #4580: hda: lost interrupt when resuming from S3 - Sony VGN-T1XP
References: <200710072217.07656.rjw@sisk.pl> <20071007231310.559dbd01@the-village.bc.nu>
In-Reply-To: <20071007231310.559dbd01@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Sun, 7 Oct 2007 22:17:06 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
>> Hi,
>>
>> IDE/ATA wizzards are kindly requested to have a look at:
>>
>> http://bugzilla.kernel.org/show_bug.cgi?id=4580#c21
>>
>> as I have no idea of what we can do about the "hard drive password vs suspend"
>> problem, if anything.
> 
> libata supports the acpi interfaces but has them off by default. Turn
> them on and it ought to just work assuming the BIOS does the right thing
> and the BIOS knows the password.

FWIW, ACPI is turned on in libata-dev.git#upstream, and as soon as 
Andrew does his next update, it should be turned on there too.  (it 
might even be in his last -mm update, not sure)

	Jeff



