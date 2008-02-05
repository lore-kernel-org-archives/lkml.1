Return-Path: <linux-kernel-owner+w=401wt.eu-S1757517AbYBEBPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517AbYBEBPx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 20:15:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757464AbYBEBPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 20:15:11 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:51886 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757247AbYBEBPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 20:15:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=VNrPm2kO2PWyQKGNrZAGMtktcgom7uxsqdx77ELXo+qMVwKzT3bPcai+rmCXbMqsPmZnnXE+gPSrtKFSDDhKXXjgLyNjL/NrLzvIysL7waGdhzJS6CNfkP3UPJqsXwDQdGSUTGj07tfvfEWkgTES7vDiK6X1sONDkPRvIjWt3jA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: ide-tape redux (was: Re:)
Date: Tue, 5 Feb 2008 02:20:22 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1202132440-26648-1-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1202132440-26648-1-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802050220.22637.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Borislav,

On Monday 04 February 2008, Borislav Petkov wrote:
> Hi Bart,
> 
> here are the pending ide-tape patches reworked which incorporate all review
> points raised so far. Several new patches are appended to the original series
> which i thought would be reasonable to sumbit along with the others. Also,
> i've applied "ide-tape: dump gcw fields on error in idetape_identify_device()"
> which is #12 and which you can simply ignore. Furthermore, #32 from the original
> series got split up into the different logical changes it dealt with, as you
> requested.

Thanks!  [ Reviewing was so much easier. ]

>  Documentation/feature-removal-schedule.txt |   14 +-
>  drivers/ide/ide-tape.c                     | 2764 +++++++++++++---------------
>  2 files changed, 1325 insertions(+), 1453 deletions(-)

applied #1-7, #9-10, #13-22 (+queued all of them for 2.6.25)

w.r.t. #8 I'm waiting for Jens to comment on blk_{get,put}_request() approach

w.r.t. #11 ide-tape uses char devices and supports DSC so it is not as obvious
as in ide-floppy case that all atomic bitops can be just removed (extra audit
and some time -mm are required) so please resync/resubmit

#12 is already in Linus' tree

Bart
