Return-Path: <linux-kernel-owner+w=401wt.eu-S933324AbYDQMBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933324AbYDQMBs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 08:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753134AbYDQMBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 08:01:38 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:50804 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbYDQMBg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 08:01:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hszLzTsOI7y1TOLfSmMAupWLD2M/mzppa0nFnJF3DewfF3xMU76BDW2U0nYzYx9+csw48kC5fapuTbBvMw5aNoqSscF+zC5AO+gHpldEunWsEi1A0bQg4oGpA3EOhvhz35CNPJzi/+s2d9u9GfVQPE/BItli9JvuX4vejyuxoEg=
Message-ID: <9ea470500804170501s5e794cd2u8cda1b46fb6fbf9f@mail.gmail.com>
Date: Thu, 17 Apr 2008 14:01:34 +0200
From: "Boris Petkov" <petkovbb@googlemail.com>
Reply-To: petkovbb@gmail.com
To: "Roel Kluin" <12o3l@tiscali.nl>
Subject: Re: [PATCH 3/6] IDE: ide-cd: fix test unsigned var < 0
Cc: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <48072ED7.7030002@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <48055F1A.9020706@tiscali.nl>
	 <200804170040.07397.bzolnier@gmail.com> <4806C952.6030102@tiscali.nl>
	 <9ea470500804170212md8ce430p42b3c1787ba95631@mail.gmail.com>
	 <48072ED7.7030002@tiscali.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2008 at 1:04 PM, Roel Kluin <12o3l@tiscali.nl> wrote:
> Boris Petkov wrote:
>
>  > I'd rather keep the "unsigned long bio_sectors;" part and do something
>  > of the likes of:
>  >
>  > bio_sectors = bio_sectors(failed_command->bio);
>  >
>  >
>  > (remove the "if (bio_sectors < 4)"-test)
>  >
>  > ... and later...
>  >
>  > sector &= ~(max(bio_sectors - 1, 3));
>  >
>  > which is, IMO, more readable.
>  >
>  > Roel, would you redo your patch please? Thanks.
>
>  While at it I also cleaned up some whitespace
>
> ---
>  Clean up cdrom_analyze_sense_data()
>
>  Signed-off-by: Roel Kluin <12o3l@tiscali.nl>

Thanks a lot.

Acked-by: Borislav Petkov <petkovbb@gmail.com>


-- 
Regards/Gruﬂ,
Boris
