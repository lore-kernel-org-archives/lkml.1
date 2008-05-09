Return-Path: <linux-kernel-owner+w=401wt.eu-S934500AbYEIBK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934500AbYEIBK2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 21:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760340AbYEIBKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 21:10:16 -0400
Received: from ozlabs.org ([203.10.76.45]:38169 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755010AbYEIBKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 21:10:14 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH/RFC] stop_machine: make stop_machine_run more virtualization friendly
Date: Fri, 9 May 2008 11:10:11 +1000
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, virtualization@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
References: <200805081520.38310.borntraeger@de.ibm.com>
In-Reply-To: <200805081520.38310.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805091110.12271.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 May 2008 23:20:38 Christian Borntraeger wrote:
> Changing stop_machine to yield the cpu to the hypervisor when yielding
> inside the guest fixed the problem for me. While I am not completely happy
> with this patch, I think it causes no harm and it really improves the
> situation for me.

Yes, this change is harmless.  I'm reworking (ie. rewriting) stop_machine at 
the moment to simplify it, and as a side effect it won't be yielding.  (The 
yield is almost useless, since there's nothing at same priority as this 
thread anyway).

I've included this patch for my next push to Linus.

Thanks,
Rusty.
