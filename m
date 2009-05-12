Return-Path: <linux-kernel-owner+w=401wt.eu-S1759979AbZELHRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759979AbZELHRz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 03:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758770AbZELHRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 03:17:45 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:33348 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758066AbZELHRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 03:17:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=IqZddSMUtIG2nOa0cpuIJwtC8ObRN/SvtQEbWE4IVcAah3HLTUUCap1YuVbEU98uoI
         hhm5Z3uPFKTh7pMMi/KlgpAMD3Ai3Ku5ct726IGZ7IoTvm15O2sPPvhz/SV/x53Srijp
         JyPOG9S/I47y7K7rFD8zMlgowI1aJAQ031+lo=
Date: Tue, 12 May 2009 09:17:39 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Borislav Petkov <petkovbb@googlemail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/14] ide-atapi: use local sense buffer
Message-ID: <20090512071739.GA24565@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@gmail.com>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Borislav Petkov <petkovbb@googlemail.com>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1241855134-4984-1-git-send-email-petkovbb@gmail.com> <1241855134-4984-10-git-send-email-petkovbb@gmail.com> <200905102332.39043.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200905102332.39043.bzolnier@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, May 10, 2009 at 11:32:38PM +0200, Bartlomiej Zolnierkiewicz wrote:

[..]

all done, testing...

> > -	pc->req_xfer = blk_rq_bytes(sense_rq);
> 
> I think that we can remove ->req_xfer now completely, patch #13.5? :)

Well, the trivial thing would be to replace the pc->req_xfer with the
naked number representing the cmd length, which is ugly. I'll think of
something more elegant when merging all those ide_create.*cmd into their
users. As always, I'm open to suggestions, of course :).

-- 
Regards/Gruss,
    Boris.
