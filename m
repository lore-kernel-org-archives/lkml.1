Return-Path: <linux-kernel-owner+w=401wt.eu-S1755752AbZBPVy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752AbZBPVy6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 16:54:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755645AbZBPVyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 16:54:08 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:37858 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804AbZBPVyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 16:54:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=TJD+S0/GAcVfOk2hfj3y/sBaJK2VJ0lxksBBg/vNPUjKFF3kfsz3XMwp5j0WkRm0St
         scSJhK2FwoSTqABH1c2wpiJ1rDMQvyZx5A0RClIKVZYOEpM0synvRUws6BVLedlKRBw9
         Bo2uwlfedEbFQKUFbRHyF6b6xX/tIbPHHyths=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 14/18] ide: use ->tf_read in ide_read_error()
Date: Mon, 16 Feb 2009 22:17:08 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc4-next-20090213; KDE/4.2.0; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080620213323.13202.71450.sendpatchset@localhost.localdomain> <49995856.0@ru.mvista.com> <49995B44.6090604@ru.mvista.com>
In-Reply-To: <49995B44.6090604@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902162217.08541.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 February 2009, Sergei Shtylyov wrote:
> Hello, I wrote:
> 
> >>>   register and handle it in ->tf_read.
> >>>   
> >>
> >>  Doesn't seem like a good name -- you can't read the features 
> >> register. I should've commented to this patch earlier, of course...

[ Yeah... preferably in June 2008 when this patch was posted... ]

> > * Add IDE_TFLAG_IN_FEATURE taskfile flag for reading Feature

Trivial s/IN_*FEATURE/IN_*ERROR/ should do the job.

I will fix it later unless you beat me to it.

> >   Moreover, the error register shoudn't be affeceted by the HOB bit, 
> > so this flag doesn't make sense.
> 
>    I meant IDE_TFLAG_IN_HOB_FEATURE, of course.

Once again blame the certain ioctl (you know which one)... :)

Thanks,
Bart
