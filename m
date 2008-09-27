Return-Path: <linux-kernel-owner+w=401wt.eu-S1753325AbYI0PHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbYI0PHo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 11:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbYI0PHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 11:07:36 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:59848 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbYI0PHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 11:07:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=VpCLZaFSkgz6YavfLzRCpt5BCxVKFk/NycVZ0BJVAksxtGXT09SDrVQGkWsyjBKf2l
         6g/x/MegIenrK1FhaHh1yuEy1UTYr44Mccdlmcw5ojKztfxDhXugAHjUx8s4fFta7+wc
         lGf0TgXsenktDZgZ3IP1Rg3YRLwqLg8BnBWh8=
Message-ID: <b9df5fa10809270807j3d8a9a1cg9dcbad4cb253fc6e@mail.gmail.com>
Date: Sat, 27 Sep 2008 21:07:33 +0600
From: "Rakib Mullick" <rakib.mullick@gmail.com>
To: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Compilation error on 2.6.27-rc5-mm1.
Cc: akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inlining failed with gcc version 3.4
The patch named  "sched-clarify-ifdef-tangle.patch" causes the
following compilation error.
 CC      kernel/sched.o
kernel/sched.c: In function `start_rt_bandwidth':
kernel/sched.c:208: sorry, unimplemented: inlining failed in call to
'rt_bandwidth_enabled': function body not available
kernel/sched.c:214: sorry, unimplemented: called from here
make[1]: *** [kernel/sched.o] Error 1
make: *** [kernel] Error 2

Thanks.
