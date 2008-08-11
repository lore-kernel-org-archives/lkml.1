Return-Path: <linux-kernel-owner+w=401wt.eu-S1751754AbYHKGhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754AbYHKGhR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 02:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750970AbYHKGhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 02:37:04 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:38954 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbYHKGhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 02:37:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent:from;
        b=Mh5GfKCOnEvushva4wVtWzo5G1RtaDVv03zBBXikNgU9vu11tyXy8BK93r69/fF/M5
         Q3X0lBblsPXjwv2NszfpgWyUtO3vHcTe1B8wt0hENV5DgvW4BC/oqv6nAbF353kt8Yk8
         m7f9lIK5Di7EurRx+kiwtGR8uXEexR2UCeKhM=
Date: Mon, 11 Aug 2008 08:36:58 +0200
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/22] ide: more work on generic ATAPI support
Message-ID: <20080811063658.GB15436@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080810153527.16255.2504.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080810153527.16255.2504.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 10, 2008 at 05:35:27PM +0200, Bartlomiej Zolnierkiewicz wrote:
> 
> Just some more work on generic ATAPI layer...
> 
> - code unifications here and there
> 
> - move IDEFLOPPY_IOCTL_FORMAT_* support to a separate file
> 
> - ide_pc_intr() no longer requires zillion of arguments
> 
> Applies on top of current pata tree, tested with ide-scsi.
> 
> diffstat:
>  drivers/ide/Makefile           |    3 
>  drivers/ide/ide-atapi.c        |  323 +++++++++++++++--
>  drivers/ide/ide-floppy.c       |  739 ++++++-----------------------------------
>  drivers/ide/ide-floppy.h       |   72 +++
>  drivers/ide/ide-floppy_ioctl.c |  245 +++++++++++++
>  drivers/ide/ide-tape.c         |  396 ++++++---------------
>  drivers/scsi/ide-scsi.c        |  178 ++-------
>  include/linux/ide.h            |  266 +++++++++-----
>  8 files changed, 1035 insertions(+), 1187 deletions(-)

ACK 1-14, looks good so far. Will review the rest of them later and do some
testing.

-- 
Regards/Gruss,
    Boris.
