Return-Path: <linux-kernel-owner+w=401wt.eu-S1757441AbXIXMc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441AbXIXMc2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 08:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbXIXMcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 08:32:20 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2249 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbXIXMcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 08:32:19 -0400
Date: Mon, 24 Sep 2007 13:32:07 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
       linux-s390@vger.kernel.org
Subject: 2.6.23-rc7-mm1 -- s390 compile failures
Message-ID: <20070924123207.GB30855@shadowen.org>
References: <20070924021716.9bfe7dfb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070924021716.9bfe7dfb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Getting compile errors on S390:

    CC      arch/s390/mm/cmm.o
  arch/s390/mm/cmm.c: In function `cmm_init':
  arch/s390/mm/cmm.c:431: error: implicit declaration of function
  				`register_oom_notifier'
  arch/s390/mm/cmm.c:443: error: implicit declaration of function
  				`unregister_oom_notifier'
  make[1]: *** [arch/s390/mm/cmm.o] Error 1
  make: *** [arch/s390/mm] Error 2

-apw
