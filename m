Return-Path: <linux-kernel-owner+w=401wt.eu-S1756485AbYIOSeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485AbYIOSeS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 14:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754183AbYIOScU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 14:32:20 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:10054 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118AbYIOScR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 14:32:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=vIRI67bRuu8A2TodVtkCX4dtKw96RLCp2bopSy2Oh4tECFjyIg7fl7A4u8MWb7nqfE
         86r29wRwHZzQukTZhQKFgQgG/ChoC6v7ONA15ZZ35lgRnSAzkXssxwrNj174DsPGZ/8P
         7lPYZKyzxhKhZvAal3PixxPy+7W8/j+TPcsLU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 00/10] ide-cd: use generic ide_issue_pc
Date: Mon, 15 Sep 2008 20:30:50 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1221392158-3848-1-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1221392158-3848-1-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809152030.51074.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Sunday 14 September 2008 13:35:48 Borislav Petkov wrote:
> Hi Bart,
> 
> here are some patches converting ide-cd to using ide_issue_pc. Next is
> replacing cdrom_transfer_packet_command with ide_transfer_pc.
> 
>  drivers/ide/ide-atapi.c  |   71 ++++++++++++++++++++++---------
>  drivers/ide/ide-cd.c     |  104 ++++++---------------------------------------
>  drivers/ide/ide-cd.h     |   30 +++++++++++++-
>  drivers/ide/ide-floppy.c |    2 +-
>  drivers/ide/ide-tape.c   |    2 +-
>  drivers/scsi/ide-scsi.c  |    3 +-
>  include/linux/ide.h      |    5 ++-
>  7 files changed, 102 insertions(+), 115 deletions(-)

Thanks for finding time to work on this.  Overall it looks good
and I applied some patches already (#1/2/4) but the rest would
need some final recasting/polishing before they can go in (please
see the individual replies for details).

Bart
