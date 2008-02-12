Return-Path: <linux-kernel-owner+w=401wt.eu-S1761288AbYBLANw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761288AbYBLANw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 19:13:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756888AbYBLANI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 19:13:08 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:11782 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756317AbYBLANC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 19:13:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=VjBSYUIlvIP4OxhyKpWUIxMIl/ER3vZgWwqCJZ/Rybz91yUInd7Bga+U+i0759FkoSQkUMMV86bE2dEYHAJUFf60eG5qaLAFul2heDRQV7DxecE5EbxOnskzspI0HncZH1tRm1cPlUerOpHU/xFncGtVC48P4HvHbRL6cvoztCw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 0/4] ide: generic packet command representation
Date: Tue, 12 Feb 2008 01:09:24 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1202718880-1793-1-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1202718880-1793-1-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802120109.24152.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 11 February 2008, Borislav Petkov wrote:
> Hi Bart,
> 
> here's the ide_atapi_pc unification series. It all went pretty smoothly along
> the search & replace line. Using driver-specific members in ide_atapi_pc like
> idefloppy_callback and idetape_callback is kinda dumb but this approach seemed
> the fastest versus unnecessary callback function signature change that will
> touch stuff all over the place. Besides, ide-tape might be gone soon so that
> would alleviate the problem.

applied all four patches, thanks!

> On a different note, i noticed ide-scsi might also need a cleanup similar to the
> other drivers. It is next on my TODO list in case you don't have anything with a
> higher prio.

I was actually hoping that you'll continue unifying ATAPI handling...

[ ide-scsi is orphaned and has (probably) unfixable problems (because of having
  dependencies on both IDE and SCSI subsystems) so it is not worth IMO but I will
  of course accept patches... ]

Thanks,
Bart
