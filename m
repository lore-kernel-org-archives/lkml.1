Return-Path: <linux-kernel-owner+w=401wt.eu-S1756803AbXLGS67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbXLGS67 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 13:58:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754133AbXLGS6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 13:58:51 -0500
Received: from odyssey.analogic.com ([204.178.40.5]:3706 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971AbXLGS6u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 13:58:50 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 07 Dec 2007 18:58:45.0293 (UTC) FILETIME=[312F55D0:01C83903]
Content-class: urn:content-classes:message
Subject: Re: Possible EXT2 race
Date: Fri, 7 Dec 2007 13:58:40 -0500
Message-ID: <Pine.LNX.4.61.0712071355200.5300@chaos.analogic.com>
in-reply-to: <20071207165101.GA26631@redhat.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Possible EXT2 race
thread-index: Acg5AzFXQ+jLGzncSKWu4akfzHIrsw==
References: <Pine.LNX.4.61.0712070808030.4642@chaos.analogic.com> <20071207165101.GA26631@redhat.com>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "Dave Jones" <davej@redhat.com>
Cc: "Linux kernel" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 7 Dec 2007, Dave Jones wrote:

> On Fri, Dec 07, 2007 at 08:15:42AM -0500, linux-os (Dick Johnson) wrote:
>
> > Dec  7 04:05:55 chaos kernel: sd 0:0:1:0: [sdb] Add. Sense: Peripheral device write fault
>
> This sounds more like a hardware problem.
>
> 	Dave
>

There was an attempt to write beyond the end of the device because
everything in the file-system was getting trashed. I can read/write
the 5 year-old SCSI physical drive with no errors from both within
linux and through the Adaptec BIOS. This problem only occurs
when I attempt to truncate a file that is being written by another
task.

> -- 
> http://www.codemonkey.org.uk
>

Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.29 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
