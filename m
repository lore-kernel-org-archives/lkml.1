Return-Path: <linux-kernel-owner+w=401wt.eu-S1752280AbYIBKog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280AbYIBKog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 06:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbYIBKoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 06:44:25 -0400
Received: from ik-out-1112.google.com ([66.249.90.183]:42055 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbYIBKoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 06:44:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=ds2Ojc+kozcFMH6t3WAetmctrvaOrcLlphKkmiK6feR9dmmlSknlzGxiTsN9q4DRVd
         zBvwDkUE7icvD1mqB2UbZTbvVe7kJ0USte97vz3bFwOazPSTHbEDIcFK8A6Jz0ogKHZe
         VuLfmTL3oWZZxhecJAO5Oszgn6PpHHPcGV8xQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Elias Oltmanns <eo@nebensachen.de>
Subject: Re: [PATCH] ide: Build fix for CONFIG_IDE_PROC_FS=n
Date: Tue, 2 Sep 2008 12:35:36 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080829213217.4826.91622.stgit@denkblock.local> <200808311752.06818.bzolnier@gmail.com> <878wub1nso.fsf@denkblock.local>
In-Reply-To: <878wub1nso.fsf@denkblock.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809021235.36429.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 September 2008, Elias Oltmanns wrote:
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> > On Friday 29 August 2008, Elias Oltmanns wrote:
> >> Recent changes have broken compilation when CONFIG_IDE_PROC_FS is not set.
> >> 
> >> Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
> >
> > Thanks!
> >
> > I integrated your fixes into guilty patches ("ide-floppy: move /proc handling
> > to ide-floppy_proc.c" and "ide-disk: move /proc handling to ide-disk_proc.c")
> > to preserve bisection.
> 
> Yes, that's fine with me, but in the case of ide-disk_proc.h things
> apparently went wrong. As of next-20080901, I still have the line
> 
> ide-disk_mod-y += ide-disk.o ide-disk_ioctl.o ide-disk_proc.o
> 
> in the Makefile. Could you please truncate that line appropriately?

Fixed, thanks for noticing.
