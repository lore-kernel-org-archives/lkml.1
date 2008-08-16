Return-Path: <linux-kernel-owner+w=401wt.eu-S1754189AbYHPRqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbYHPRqB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 13:46:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620AbYHPRpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 13:45:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:35774 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbYHPRpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 13:45:19 -0400
Date: Sat, 16 Aug 2008 10:44:04 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH RFC 3/3] x86: use mwait for trigger API
Message-ID: <20080816104404.070e0c14@infradead.org>
In-Reply-To: <48A70192.7020002@goop.org>
References: <48A70192.7020002@goop.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Aug 2008 09:34:26 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> If the cpu implements monitor/mwait, use it for the trigger API.
> 
> TODO: work out if any mwait hints are going to be useful here.


monitor/mwait is rather really expensive.. are we really sure we want
to use this?
(from an Intel cpu perspective the answer is very likely no; but I don't
know what AMD does here)


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
