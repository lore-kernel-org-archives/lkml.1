Return-Path: <linux-kernel-owner+w=401wt.eu-S1756732AbYHCMSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732AbYHCMSQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 08:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753986AbYHCMSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 08:18:03 -0400
Received: from www17.your-server.de ([213.133.104.17]:48616 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572AbYHCMSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 08:18:01 -0400
Subject: next-20080801: BUG in pktcdvd while mounting dvd
From: Thomas Meyer <thomas@m3y3r.de>
To: Linux-Next <linux-next@vger.kernel.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>, alan@lxorguk.ukuu.org.uk,
       petero2@telia.com
Content-Type: text/plain
Date: Sun, 03 Aug 2008 14:18:04 +0200
Message-Id: <1217765884.9907.5.camel@dhcppc0>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings.

Please have a look at this bug report:

http://kerneloops.org/raw.php?rawid=47211

reverting commit 5b6155ee70e9c4d2ad7e6f514c8eee06e2711c3a fixes the
problem

commit 5b6155ee70e9c4d2ad7e6f514c8eee06e2711c3a
Author: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date:   Fri Jul 4 09:29:16 2008 +0200

    pktcdvd: push BKL down into driver
    
    Push the lock_kernel down into the driver and switch to
unlocked_ioctl
    
    [akpm@linux-foundation.org: build fix]
    Signed-off-by: Alan Cox <alan@redhat.com>
    Acked-by: Peter Osterlund <petero2@telia.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Jens Axboe <jens.axboe@oracle.com>


