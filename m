Return-Path: <linux-kernel-owner+w=401wt.eu-S1753939AbYLSTb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939AbYLSTb1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 14:31:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753663AbYLSTbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 14:31:10 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:57750 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbYLSTbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 14:31:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=r03nViyDzA7EKsAHxPED//dzDgnCpGlGnAdN5/c/Z+upnVec8n1xMBib1FNugE/ANb
         sadOMT/kZGfV+1kK+bLP7MIn3ysepV9bbdXu5tUeTNe6slq73O9S7gH5e3eqVgvKJZtq
         PxPja4E562aYln6PbKN2AVl661RQ8dMBQ/R74=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] ide: Fix ata_id_has_dword_io to return DWORD I/O support properly
Date: Fri, 19 Dec 2008 20:30:34 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rc8-next-20081219; KDE/4.1.3; i686; ; )
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, Jeff Garzik <jeff@garzik.org>,
       Mario Schwalbe <schwalbe@inf.tu-dresden.de>,
       linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
References: <494A5BBF.8000807@inf.tu-dresden.de> <200812190013.10156.bzolnier@gmail.com> <20081219105013.0e43c364@lxorguk.ukuu.org.uk>
In-Reply-To: <20081219105013.0e43c364@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812192030.34554.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 December 2008, Alan Cox wrote:
> > Sure, we can always improve things further later.  However Mario's patch
> > is _definitely_ an improvement over the _current_ code.  Don't you agree?
> 
> No actually I don't. The current head dev code checks ATA > 7 as the
> indicator that this bit is used for treacherous computing. That means the
> behaviour for all the older drives is clearly back compatible with old
> Linux behaviour.
> 
> Doing it that way around means we don't have any worries about changing
> existing behaviours.

Please try to verify old Linux behaviour compatiblity statement with
some ATA-[2..7] devices...  They have old ATA-1 bit set to _zero_...

Mario: I don't have anymore time to spend on fixing libata problems so
I'll be leaving ata_id_has_dword_io() issues up to libata maintainers,
sorry for inconvenience!

Thanks,
Bart
