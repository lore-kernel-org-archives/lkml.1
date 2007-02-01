Return-Path: <linux-kernel-owner+w=401wt.eu-S1422896AbXBAOBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422896AbXBAOBR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 09:01:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422898AbXBAOBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 09:01:17 -0500
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:56480 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422896AbXBAOBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 09:01:16 -0500
Subject: Re: [PATCH] radio modems sitting on serial port are not for s390
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Al Viro <viro@ftp.linux.org.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <E1HCcN1-0007Si-0C@ZenIV.linux.org.uk>
References: <E1HCcN1-0007Si-0C@ZenIV.linux.org.uk>
Content-Type: text/plain
Organization: IBM Corporation
Date: Thu, 01 Feb 2007 15:01:13 +0100
Message-Id: <1170338473.5629.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-01 at 13:52 +0000, Al Viro wrote:
> Won't build (request_irq()/free_irq()), even if you manage to find an
> s390 box with 8250-compatible UART they are expecting.

Since the full blown Kconfig rework did not make it upstream this patch
is a good solution for now. 

-- 
blue skies,
  Martin.

Martin Schwidefsky
Linux for zSeries Development & Services
IBM Deutschland Entwicklung GmbH

"Reality continues to ruin my life." - Calvin.


