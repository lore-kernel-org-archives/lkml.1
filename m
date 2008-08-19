Return-Path: <linux-kernel-owner+w=401wt.eu-S1754436AbYHSGX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436AbYHSGX0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 02:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752888AbYHSGXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 02:23:16 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:30688 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbYHSGXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 02:23:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent:from;
        b=N9gHE4wyokDuhW8n/pFhNNa/g/7LkJUPVSU8WptIEznJw0SHEyVQzv/j3iG4ItB4km
         Q8xa3XD8xHUW3WiKMoaBQZvHstCjmfSBJIswMMdhcwS26fIGrr0A42ux5BiYS4JBT7iL
         7I638D9AyuSNysqk/6/1kVKybkJZ3DPx5Qxac=
Date: Tue, 19 Aug 2008 08:23:17 +0200
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 0/5] ide debugging macros
Message-ID: <20080819062317.GB30315@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1218993826-4571-1-git-send-email-petkovbb@gmail.com> <200808182308.38345.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808182308.38345.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2008 at 11:08:38PM +0200, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
> On Sunday 17 August 2008, Borislav Petkov wrote:
> > Hi Bart,
> > 
> > here's something i've been wanting to do for a long time: debugging macros. The
> > reason for it is that i got tired of adding debug printk's everytime i'm testing
> > something so here we go.
> > 
> > The debugging macro is similar to the old ones but is one for all drivers
> > (currently only ide-floppy), is nice on branch prediction and is controlled by a
> > drive->debug_mask switch which is a module parameter and as such can be set at
> > module load time, of course. I've been thinking of adding also a sysfs attribute
> > too but can't seem to find quite the justification for it so no sysfs for now :)
> 
> if you look closely you should already find it :)
> 
> [ module parameters are exported through sysfs and it uses 0644 mask ]

Aah, i get it now, it's /sys/bus/ide/drivers/ide-floppy/module/parameters/debug_mask.
However, it'd be better if it were /sys/bus/ide/drivers/ide-floppy/debug_mask.
Probably a symlink or a true /sysfs parameter? Maybe later :).

-- 
Regards/Gruss,
    Boris.
