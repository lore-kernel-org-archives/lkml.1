Return-Path: <linux-kernel-owner+w=401wt.eu-S1757926AbYBNPr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926AbYBNPr5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 10:47:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753004AbYBNPro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 10:47:44 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42706 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751634AbYBNPrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 10:47:42 -0500
Subject: Re: "mount: could not find filesystem" - aacraid? (was: Re:
	2.6.26-git0: IDE oops during boot)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Nish Aravamudan <nish.aravamudan@gmail.com>,
       Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, ananth@in.ibm.com,
       Andi Kleen <andi@firstfloor.org>, linux-scsi@vger.kernel.org,
       aacraid@adaptec.com
In-Reply-To: <200802141307.42169.bzolnier@gmail.com>
References: <20080206105334.GA3664@elf.ucw.cz>
	 <47B40DF2.10009@linux.vnet.ibm.com> <200802141301.35032.bzolnier@gmail.com>
	 <200802141307.42169.bzolnier@gmail.com>
Content-Type: text/plain
Date: Thu, 14 Feb 2008 09:47:32 -0600
Message-Id: <1203004052.3189.18.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-02-14 at 13:07 +0100, Bartlomiej Zolnierkiewicz wrote:
> > I worry that another git-bisect session will be needed unless SCSI
> > developers are already aware of the problem source.
> 
> Yinghai Lu noticed that it may be actually a SES problem:
> 
> http://lkml.org/lkml/2008/2/14/88
> 
> [ I overlooked the above mail, sorry ]

Only if SES is enabled, is it (CONFIG_SCSI_ENCLOSURE)? ... is there
actually a dmesg of the failing system somewhere, I couldn't find it in
the (somewhat long) thread?

James




