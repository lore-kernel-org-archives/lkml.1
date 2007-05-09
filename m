Return-Path: <linux-kernel-owner+w=401wt.eu-S1757427AbXEIKnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427AbXEIKnr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 06:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755656AbXEIKnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 06:43:37 -0400
Received: from wr-out-0506.google.com ([64.233.184.229]:28688 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320AbXEIKng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 06:43:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Q4Zw2LGOOcicKHynMQnZu70oUL4MiykHMGvRcESC6wMWuxFdACn+rEKHmOigDRyaf1FibPbeQGQ8rhZMV10fm54QcqdkqBcSrEGB8QCi7F2+EPZ+FH41sigjn4JWAGo3S1GU5lXRkjjNvrveHldH1flUTpu3yBlM4bEE2B8jkoc=
Message-ID: <a44ae5cd0705090343n6ddae15he51198a0e448198a@mail.gmail.com>
Date: Wed, 9 May 2007 03:43:34 -0700
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       "Anton Vorontsov" <cbou@mail.ru>
Subject: =?WINDOWS-1252?Q?Re:_2.6.21-mm2_--_Compile_er?= =?WINDOWS-1252?Q?ror:_include/linux/power=5Fsupp?= =?WINDOWS-1252?Q?ly.h:125:_error:_field_=91chan?= =?WINDOWS-1252?Q?ged=5Fwork=92_has_incomplete_type?=
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  CC      drivers/power/power_supply_core.o
In file included from drivers/power/power_supply_core.c:18:
include/linux/power_supply.h:125: error: field 'changed_work' has
incomplete type
drivers/power/power_supply_core.c: In function 'power_supply_changed_work':
drivers/power/power_supply_core.c:25: warning: type defaults to 'int'
in declaration of '__mptr'
drivers/power/power_supply_core.c:25: warning: initialization from
incompatible pointer type
drivers/power/power_supply_core.c: In function 'power_supply_changed':
drivers/power/power_supply_core.c:57: warning: implicit declaration of
function 'schedule_work'
drivers/power/power_supply_core.c: In function 'power_supply_register':
drivers/power/power_supply_core.c:103: warning: implicit declaration
of function 'INIT_WORK'
drivers/power/power_supply_core.c: In function 'power_supply_unregister':
drivers/power/power_supply_core.c:128: warning: implicit declaration
of function 'flush_scheduled_work'
make[2]: *** [drivers/power/power_supply_core.o] Error 1
