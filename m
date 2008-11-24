Return-Path: <linux-kernel-owner+w=401wt.eu-S1752199AbYKXF6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbYKXF6N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 00:58:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750837AbYKXF55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 00:57:57 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:53934 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750806AbYKXF54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 00:57:56 -0500
Subject: Re: about TRIM/DISCARD support and barriers
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Dongjun Shin <djshin90@gmail.com>
Cc: Tejun Heo <teheo@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dwmw2@infradead.org, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, chris.mason@oracle.com,
       Matthew Wilcox <matthew@wil.cx>
In-Reply-To: <7fe698080811232140ie896cc8m735a25261f447c47@mail.gmail.com>
References: <4928E010.4090801@kernel.org> <4929023C.2060302@suse.de>
	 <49290CEB.7070509@suse.de>
	 <7fe698080811232140ie896cc8m735a25261f447c47@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 24 Nov 2008 14:57:47 +0900
Message-Id: <1227506267.25499.22.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-24 at 14:40 +0900, Dongjun Shin wrote:
> On Sun, Nov 23, 2008 at 4:57 PM, Tejun Heo <teheo@suse.de> wrote:
> > Tejun Heo wrote:
> >> Dongjun, the only doc I can find about ATA TRIM is the following one.
> >>
> >>  http://t13.org/Documents/UploadedDocuments/docs2007/e07154r3-Data_Set_Management_Proposal_for_ATA-ACS2.pdf
> >>
> >> And AFAICS this hasn't made into ACS yet.  Is this what you guys are
> >> gonna implement and Windows7 is gonna use?
> >
> 
> Sorry, I thought the trim spec has got into the final ACS, but it's not yet.
> Microsoft can collaborate with SSD vendors for their internal evaluation &
> feedback for Win7(with NDA between them, of course).

Actually so can we assuming the developers are willing.  If we have to
sign an NDA to work with them, the Linux Foundation can stand as
corporate guarantor for it:

http://www.linuxfoundation.org/en/NDA_program

It's crafted to allow development of open source drivers.  It still
requires individual developers to sign an NDA agreement with the LF (and
the LF then does a corporate one with the companies involved).

James


