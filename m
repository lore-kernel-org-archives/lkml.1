Return-Path: <linux-kernel-owner+w=401wt.eu-S1753770AbYJXHEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770AbYJXHEd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 03:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529AbYJXHEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 03:04:23 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:51789 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbYJXHEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 03:04:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=PRBHm1RtjIpNrGiTPtM90TfqFKOvFal1JzyjGnsK1iYYK6OXqlaC46/riBTsyLCddB
         ivQaw6tj+Vd+UWDODCPHbGwBH7SbU2PGCe6GED8TtYfx4h2HbyEtVab4pf4hU7pKIeJt
         xwhEIZFnQ76/Yk9Kw5YVazuGscZt90+gm54M8=
Message-ID: <a4423d670810240004t2d7c3bdah2bea77a6a49bb7c4@mail.gmail.com>
Date: Fri, 24 Oct 2008 11:04:21 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: jens.axboe@oracle.com, tj@kernel.org, torvalds@linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Subject: 2.6.27-rc1 (2fca5c): libata: kernel cant boot
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

commit 2fca5ccf97d2c28bcfce44f5b07d85e74e3cd18e
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Wed Oct 22 09:34:49 2008 +0200

    libata: switch to using block layer tagging support


This kernel can not read even 0 sector on disk with rootfs. It
initialized disk, but cant read it at all.
 CMD646 on Sparc

Rverting helped.
