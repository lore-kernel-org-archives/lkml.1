Return-Path: <linux-kernel-owner+w=401wt.eu-S1753805AbYIJLVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805AbYIJLVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 07:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbYIJLVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 07:21:13 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:27847 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbYIJLVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 07:21:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent:from;
        b=qxLolRUsVXK/PD5H1BvxbKo38o0w2dGj4mUsd+DrI8EnsUbcdId/GZ6zxzHiw4Bmxt
         xEmRcmn1ATl+SWAAZxwqgdBZeDFBPJzFchiGKU9W52BvO2GRZwCWptlVFIzOgnCNZy4Q
         T87uuaOjg5Y+RgleljC2t0YrcZUzPlMASV5w0=
Date: Wed, 10 Sep 2008 13:20:44 +0200
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/18] ide: add generic ATA/ATAPI disk driver
Message-ID: <20080910112044.GB10263@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080907221424.24285.81137.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080907221424.24285.81137.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2008 at 12:14:24AM +0200, Bartlomiej Zolnierkiewicz wrote:
> 
> [ Borislav, this is the 'futuristic' stuff that we were talking about. :) ]
> 
> Hi,
> 
> This patch series adds a generic ATA/ATAPI disk driver (ide-gd) replacing
> ide-disk and ide-floppy drivers.  It is achieved by moving the common code
> to ide-gd.c, adding struct ide_disk_ops (which is used to abstract protocol
> specific details) and updating ide-{disk,floppy}.c accordingly.
> 
> The main goal is to make the code more maintainable / easier to extend later.
> As an immediate result we get driver specific debugging support for ATA disks
> and ability for driver specific Power Management for ATAPI devices.  Otherwise
> it is really an initial merge (which means that in the future the code can be
> further unified, struct ide_disk_ops can be made more fine-grained etc.).

Looks cool, ACK with some comments/questions in separate mail. Will test on my
Iomega ZIP drive when I get back.

-- 
Regards/Gruss,
    Boris.
