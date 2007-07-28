Return-Path: <linux-kernel-owner+w=401wt.eu-S1751995AbXG1M6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbXG1M6V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 08:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751135AbXG1M6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 08:58:08 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:29723 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbXG1M6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 08:58:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=JzThAMNm3DLe53lSIHHrdt0O9j7GavEQhMy3ToNScfLEi/3rgDSPY2DCmVO0/+OzDNRGZEqtRJVnEusZH05qYLuw9QK6LD7CnHNTd77c7Jbiu+dLgGFfOZJf2onOhgYOa2ZcaHWpzkIPfsBGak64OQZ64RQvYf0nkrVlz+0N2zU=
Message-ID: <46AB3C6A.2070209@googlemail.com>
Date: Sat, 28 Jul 2007 14:54:02 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-scsi@vger.kernel.org
Subject: BSG: BLK_DEV_BSG=y , BLOCK=n compile error
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

BSG does not compile without BLOCK set :

...

block/bsg.c: In function 'blk_fill_sgv4_hdr_rq':
block/bsg.c:186: error: 'BLK_MAX_CDB' undeclared (first use in this function)
block/bsg.c:186: error: (Each undeclared identifier is reported only once
block/bsg.c:186: error: for each function it appears in.)
block/bsg.c:186: error: dereferencing pointer to incomplete type
block/bsg.c:186: error: dereferencing pointer to incomplete type
block/bsg.c:186: error: dereferencing pointer to incomplete type
block/bsg.c:186: error: dereferencing pointer to incomplete type
block/bsg.c:188: error: dereferencing pointer to incomplete type
block/bsg.c:193: error: implicit declaration of function 'blk_verify_command'
block/bsg.c:193: error: dereferencing pointer to incomplete type
block/bsg.c:201: error: dereferencing pointer to incomplete type
block/bsg.c:202: error: dereferencing pointer to incomplete type
block/bsg.c:202: error: 'REQ_TYPE_BLOCK_PC' undeclared (first use in this function)
block/bsg.c:204: error: dereferencing pointer to incomplete type
block/bsg.c:205: error: dereferencing pointer to incomplete type
block/bsg.c:206: error: dereferencing pointer to incomplete type
block/bsg.c:206: error: dereferencing pointer to incomplete type
block/bsg.c:207: error: dereferencing pointer to incomplete type
block/bsg.c:208: error: dereferencing pointer to incomplete type
block/bsg.c:208: error: 'BLK_DEFAULT_SG_TIMEOUT' undeclared (first use in this function)
block/bsg.c: In function 'bsg_validate_sgv4_hdr':
block/bsg.c:223: error: 'BLK_MAX_CDB' undeclared (first use in this function)
block/bsg.c:225: error: dereferencing pointer to incomplete type
block/bsg.c:226: error: dereferencing pointer to incomplete type
block/bsg.c: In function 'bsg_map_hdr':
block/bsg.c:270: error: implicit declaration of function 'blk_get_request'
block/bsg.c:270: warning: assignment makes pointer from integer without a cast
block/bsg.c:279: error: 'QUEUE_FLAG_BIDI' undeclared (first use in this function)
block/bsg.c:279: error: dereferencing pointer to incomplete type
block/bsg.c:279: error: dereferencing pointer to incomplete type
block/bsg.c:284: warning: assignment makes pointer from integer without a cast
block/bsg.c:289: error: dereferencing pointer to incomplete type
block/bsg.c:292: error: implicit declaration of function 'blk_rq_map_user'
block/bsg.c:313: error: implicit declaration of function 'blk_put_request'
block/bsg.c:315: error: implicit declaration of function 'blk_rq_unmap_user'
block/bsg.c:315: error: dereferencing pointer to incomplete type
block/bsg.c: In function 'bsg_rq_end_io':
block/bsg.c:327: error: dereferencing pointer to incomplete type
block/bsg.c: In function 'bsg_add_command':
block/bsg.c:351: error: dereferencing pointer to incomplete type
block/bsg.c:352: error: dereferencing pointer to incomplete type
block/bsg.c:358: error: dereferencing pointer to incomplete type
block/bsg.c:359: error: dereferencing pointer to incomplete type
block/bsg.c:360: error: dereferencing pointer to incomplete type
block/bsg.c:368: error: dereferencing pointer to incomplete type
block/bsg.c:369: error: implicit declaration of function 'blk_execute_rq_nowait'
block/bsg.c: In function 'blk_complete_sgv4_hdr_rq':
block/bsg.c:426: error: dereferencing pointer to incomplete type
block/bsg.c:427: error: dereferencing pointer to incomplete type
block/bsg.c:428: error: dereferencing pointer to incomplete type
block/bsg.c:432: error: dereferencing pointer to incomplete type
block/bsg.c:435: error: dereferencing pointer to incomplete type
block/bsg.c:436: error: dereferencing pointer to incomplete type
block/bsg.c:440: error: dereferencing pointer to incomplete type
block/bsg.c:447: error: dereferencing pointer to incomplete type
block/bsg.c:449: error: dereferencing pointer to incomplete type
block/bsg.c: In function 'bsg_put_device':
block/bsg.c:723: error: implicit declaration of function 'blk_put_queue'
block/bsg.c: In function 'bsg_add_device':
block/bsg.c:745: error: dereferencing pointer to incomplete type
block/bsg.c:753: error: dereferencing pointer to incomplete type
block/bsg.c: In function 'bsg_ioctl':
block/bsg.c:884: error: implicit declaration of function 'scsi_cmd_ioctl'
block/bsg.c:898: error: dereferencing pointer to incomplete type
block/bsg.c:899: error: dereferencing pointer to incomplete type
block/bsg.c:900: error: dereferencing pointer to incomplete type
block/bsg.c:901: error: implicit declaration of function 'blk_execute_rq'
block/bsg.c: In function 'bsg_unregister_queue':
block/bsg.c:933: error: dereferencing pointer to incomplete type
block/bsg.c:939: error: dereferencing pointer to incomplete type
block/bsg.c: In function 'bsg_register_queue':
block/bsg.c:967: error: dereferencing pointer to incomplete type
block/bsg.c:970: error: dereferencing pointer to incomplete type
block/bsg.c:1005: error: dereferencing pointer to incomplete type
block/bsg.c:1006: error: dereferencing pointer to incomplete type
make[1]: *** [block/bsg.o] Error 1
make: *** [block] Error 2
make: *** Waiting for unfinished jobs....

...

A solution would be to move 'endif # BLOCK' in block/Kconfig after config BLK_DEV_BSG and 
before source block/Kconfig.iosched but that would move BSG inside the BLOCK menu.

Regards,

Gabriel C
