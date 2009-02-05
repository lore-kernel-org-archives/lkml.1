Return-Path: <linux-kernel-owner+w=401wt.eu-S1756800AbZBEGuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800AbZBEGuv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 01:50:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbZBEGul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 01:50:41 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:52712 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbZBEGuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 01:50:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-type:content-disposition
         :in-reply-to:user-agent;
        b=KLLilPiWIkdXBTn5RovVsXl5KtEtZs8ZLoWxeSYQ9wKfXtQLAE/VMdzjW7+0Vmk4QZ
         ff1dnd4f9JNMLdZz1vGP8DKJRiXiserrTaK6CsFS3/jc9tTIjgFovs0uj8ATjFIjnDya
         Db0kTERFZJtVcApOzUvfimj8wbHCCtmTW+Zkk=
Date: Thu, 5 Feb 2009 07:50:35 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] ide: remove ->end_request method
Message-ID: <20090205065035.GA32418@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090201192732.1592.76435.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090201192732.1592.76435.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 01, 2009 at 08:27:32PM +0100, Bartlomiej Zolnierkiewicz wrote:
> 
> by-product of some other WIP...
> 
> on top of "[PATCH 00/15] weekly IDE updates" patchset
> [ http://marc.info/?l=linux-kernel&m=123351051303529&w=2 ]
> 
> diffstat:
>  drivers/ide/ide-atapi.c    |   17 +++--
>  drivers/ide/ide-cd.c       |    1 
>  drivers/ide/ide-disk.c     |    1 
>  drivers/ide/ide-floppy.c   |  130 ++++++++++++++++-----------------------------
>  drivers/ide/ide-gd.c       |    6 --
>  drivers/ide/ide-gd.h       |    2 
>  drivers/ide/ide-io.c       |   21 ++++---
>  drivers/ide/ide-tape.c     |  124 ++++++++++++++----------------------------
>  drivers/ide/ide-taskfile.c |   16 +----
>  include/linux/ide.h        |   16 +++--
>  10 files changed, 127 insertions(+), 207 deletions(-)

ACK.

-- 
Regards/Gruss,
    Boris.
