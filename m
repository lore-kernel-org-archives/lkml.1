Return-Path: <linux-kernel-owner+w=401wt.eu-S1755891AbXGVNys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891AbXGVNys (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 09:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbXGVNyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 09:54:38 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:30173 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbXGVNyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 09:54:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=tl30xODeef8mrpImI/r1Xv6Zk5736ntl2kPTSl9xcEWzcPK4TBE/+5HyumuFszjkJ9+Zf4GEv0N8tEUH1OqhITbyT7XwBBPuIzXBsIO6Ybh8aEIyYa7PjOBgoLqB0fvzdqhmwiTQGsmqwRnFIudjUOIpS4CEzWAWW/GShQuN1BQ=
Message-ID: <46A36115.3070600@googlemail.com>
Date: Sun, 22 Jul 2007 15:52:21 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Lieven Willems <lw_linux@hotmail.com>, Alan Cox <alan@redhat.com>,
       linux-scsi@vger.kernel.org
Subject: drivers/scsi/sym53c416.c - address of 'sym53c416*' will always evaluate
 as 'true' , warnings
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I got this warnings on current git with gcc 4.2.1 :


...

drivers/scsi/sym53c416.c: In function 'sym53c416_detect':
drivers/scsi/sym53c416.c:638: warning: the address of 'sym53c416' will always evaluate as 'true'
drivers/scsi/sym53c416.c:644: warning: the address of 'sym53c416_1' will always evaluate as 'true'
drivers/scsi/sym53c416.c:650: warning: the address of 'sym53c416_2' will always evaluate as 'true'
drivers/scsi/sym53c416.c:656: warning: the address of 'sym53c416_3' will always evaluate as 'true'

...


Regards,

Gabriel C
