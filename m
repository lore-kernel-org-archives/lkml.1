Return-Path: <linux-kernel-owner+w=401wt.eu-S1760119AbZADSmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760119AbZADSmt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 13:42:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751638AbZADSmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 13:42:37 -0500
Received: from casper.infradead.org ([85.118.1.10]:45875 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbZADSmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 13:42:36 -0500
Date: Sun, 4 Jan 2009 10:44:25 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: "Jaswinder Singh Rajput" <jaswinderlinux@gmail.com>
Cc: "Matthew Wilcox" <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, mingo@elte.hu, fweisbec@gmail.com,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 2/4] fastboot: make scsi probes asynchronous
Message-ID: <20090104104425.4bee0c95@infradead.org>
In-Reply-To: <3f9a31f40901041038w47493205m9fcd87fe237ec257@mail.gmail.com>
References: <20090104092430.7ffd2c41@infradead.org>
	<20090104092940.11943797@infradead.org>
	<20090104180515.GD2002@parisc-linux.org>
	<20090104101353.05e8df09@infradead.org>
	<3f9a31f40901041038w47493205m9fcd87fe237ec257@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Jan 2009 00:08:42 +0530
"Jaswinder Singh Rajput" <jaswinderlinux@gmail.com> wrote:

> On Sun, Jan 4, 2009 at 11:43 PM, Arjan van de Ven
> <arjan@infradead.org> wrote:
> >
> > just checked;
> > my box has CONFIG_SCSI_SCAN_ASYNC=y set for both cases
> > it seems to be about 0.1 seconds win still though...
> > sounds little, but a kernel boot should be less than a second, so
> > that is still 10%. And it's obviously also disk dependent..
> > (I used libata connected disks obviously)
> >
> 
> Do you also have boot time numbers for RAM and/or flash based
> filesystem (disk-less)

my laptop with a pretty nice SSD shows a similar kind of behavior
(bit shorter in time, but there the entire kernel boot is shorter as a
whole)



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
