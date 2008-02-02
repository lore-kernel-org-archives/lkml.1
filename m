Return-Path: <linux-kernel-owner+w=401wt.eu-S1762928AbYBBDFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762928AbYBBDFM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 22:05:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759657AbYBBDE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 22:04:58 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:29381 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757743AbYBBDE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 22:04:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=wNBVZuS9Q+8s3NG3s6smB5mSFsVwNbcs3WHQxybisTXpGNWqr73IjgQzTNWDKREJomC1B8zkfr9KZbnyi4nMVCOpoAcIvmm7HLY6fYj3B7V7nkrJrIujCe93Zq7X8ouwkavIVykbizoy/+PjYOZ4WJQV7iZJwGxaA8toD+Su2D0=
Message-ID: <47A3DDD2.2010600@gmail.com>
Date: Sat, 02 Feb 2008 12:04:50 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Dan Nica <timi@crystal.rdstm.ro>
CC: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: SiI 3512 Serial ATA Controller - kernel 2.6.23
References: <Pine.LNX.4.63.0801222230470.4758@crystal.rdstm.ro> <47965AA7.4080703@garzik.org> <Pine.LNX.4.63.0801231244040.28840@crystal.rdstm.ro>
In-Reply-To: <Pine.LNX.4.63.0801231244040.28840@crystal.rdstm.ro>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Nica wrote:
> those errors apears only when I use the harddrives with
> the sii controller and only when I make operation between
> the onboard sata and the sii sata controller, operations between 
> ide and drives that are on sii works perfectly...

Hmm.. Your drive is raising ABRT on writes.  It can point to a number of
things including media access error and transmission error.  It's
basically a catch-all bit.  In the log, libata EH slowed down the device
to udma33 without any effect so I don't think it's transmission error
caused by cable misdetection or miswiring (mid connector connected to
the only drive on the cable).  What does 'smartctl -a' say about the drive?

-- 
tejun
