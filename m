Return-Path: <linux-kernel-owner+w=401wt.eu-S1757856AbXHULY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757856AbXHULY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 07:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509AbXHULYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 07:24:49 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:52582 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbXHULYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 07:24:48 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [accounting regression since rc1]  scheduler updates
Date: Tue, 21 Aug 2007 13:24:13 +0200
User-Agent: KMail/1.9.7
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jan Glauber <jang@linux.vnet.ibm.com>, heiko.carstens@de.ibm.com,
       Paul Mackerras <paulus@samba.org>
References: <20070812163225.GA11996@elte.hu> <200708211243.15223.borntraeger@de.ibm.com> <20070821111544.GA32064@elte.hu>
In-Reply-To: <20070821111544.GA32064@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708211324.13442.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 21. August 2007 schrieb Ingo Molnar:
> you mean to revert b27f03d4bd? I'd really like to see this fixed for 
> real for s390 + CONFIG_VIRT_CPU_ACCOUNTING=y. (which seems to be the 
> only case affected)

Not a complete revert, but an ifdef-workaround. I wrote this patch last week 
and you were on cc:
http://marc.info/?l=linux-mm-commits&m=118737949222362&w=2

This patch should fix s390 and let everybody else use your new code. If you 
are conviced that we get a better solution before 2.6.23 hits the street, 
thats fine with me. 

Christian
