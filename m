Return-Path: <linux-kernel-owner+w=401wt.eu-S1760259AbXHUHVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760259AbXHUHVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 03:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755611AbXHUHVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 03:21:08 -0400
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:35420 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045AbXHUHVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 03:21:07 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [accounting regression since rc1]  scheduler updates
Date: Tue, 21 Aug 2007 09:20:54 +0200
User-Agent: KMail/1.9.7
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jan Glauber <jang@linux.vnet.ibm.com>, heiko.carstens@de.ibm.com,
       Paul Mackerras <paulus@samba.org>
References: <20070812163225.GA11996@elte.hu> <1187634782.4028.10.camel@localhost> <20070820190509.GA3714@elte.hu>
In-Reply-To: <20070820190509.GA3714@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708210920.54565.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 20. August 2007 schrieb Ingo Molnar:
> ok. Just to make it sure wrt. release-management: you said s390 
> sched_clock() is currently at least as precise as stime/utime - so this 
> would suggest that there is no regression over v2.6.22? Regardless of 

On current git s390 has a sched_clock implementaton based on real time. That 
means we have no knowledge about steal time. E.g. if you only get 50% of your 
physial cpu from the hypervisor on 2.6.22 a single cpu bound process has 50% 
in top while on 2.6.23-rc top shows 100%, so yes, there is a regression.

Christian



