Return-Path: <linux-kernel-owner+w=401wt.eu-S1752720AbYHLRvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbYHLRvQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 13:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbYHLRu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 13:50:59 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:28811 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbYHLRu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 13:50:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=qy3GjBplGqahZCpkyb1OFpn6j3kA8nV/zCZzOerdclngOA6LzWE9QKwPFQpKjEKNRo
         JC/sJWWqQZXzygfO6GYgG3Edk/q9eECBxGu3/MOCSRYbA6OZ/dmIqpX1iOK6g7VXRa1h
         86zENIqGueRG496vA8K9R5w/ONeF2mfN3+5/Y=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH 11/22] ide: add ide_set_media_lock() helper
Date: Tue, 12 Aug 2008 19:48:30 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080810153527.16255.2504.sendpatchset@localhost.localdomain> <200808121105.49645.bzolnier@gmail.com> <9ea470500808120637w354b3ae0w3ceca791344bd7cc@mail.gmail.com>
In-Reply-To: <9ea470500808120637w354b3ae0w3ceca791344bd7cc@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808121948.31030.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 August 2008, Boris Petkov wrote:
> >> Are we switching to SCSI opcodes? What about the generic packet commands in
> >> <include/linux/cdrom.h>?
> >
> > I prefer to use them when possible but there is no strict policy.
> >
> > [ SCSI defines are shorter, one of the drivers was using them already
> >  and it also makes easier for comparing code with SCSI. ]
> 
> I still think we should stick to one format or the other. All
> the drivers' functions, for example, comply with a naming scheme
> (ide_cd/ide_floppy/...) so opcodes shouldn't be an exception, imho...

Some opcodes are only in <linux/cdrom.h> while the other ones only
in <scsi/scsi.h> so it is not that simple without additional effort.

I don't have a time for it at the moment (+ I consider it a low-prio
task).  However if you would like to look into it, please go ahead.

Thanks,
Bart
