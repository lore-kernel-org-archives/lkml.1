Return-Path: <linux-kernel-owner+w=401wt.eu-S1754982AbYJHRby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982AbYJHRby (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 13:31:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754557AbYJHRbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 13:31:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45999 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501AbYJHRbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 13:31:46 -0400
Date: Wed, 8 Oct 2008 19:37:57 +0200
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Subject: ksoftirqd accounting broken in 2.6.27-rc9
Message-ID: <20081008173757.GA24560@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On one test box running 2.6.27rc9 for a few hours I got:

  PID TTY      STAT   TIME COMMAND
    1 ?        Ss     0:01 init [3]  
    2 ?        S<     0:00 [kthreadd]
    3 ?        S<     0:00 [migration/0]
    4 ?        S<     0:00 [ksoftirqd/0]
    5 ?        S<     0:00 [watchdog/0]
    6 ?        S<     0:00 [migration/1]
    7 ?        S<     0:00 [ksoftirqd/1]
    8 ?        S<     0:00 [watchdog/1]
    9 ?        S<     0:00 [migration/2]
   10 ?        S<   21133795:38 [ksoftirqd/2]
...
   19 ?        S<   21133795:38 [ksoftirqd/5]
...
   25 ?        S<   21133795:38 [ksoftirqd/7]

The other kernel threads seem to have correct accounting.

-Andi


-- 
ak@linux.intel.com
