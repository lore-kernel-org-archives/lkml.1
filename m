Return-Path: <linux-kernel-owner+w=401wt.eu-S1755968AbZETIml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbZETIml (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 04:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753760AbZETImd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 04:42:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:36640 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbZETImd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 04:42:33 -0400
Subject: Re: [PATCH][KVM][retry 3] Add support for Pause Filtering to AMD
 SVM
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: Mark Langsdorf <mark.langsdorf@amd.com>,
       Joerg Roedel <joerg.roedel@amd.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <4A13C199.5020400@redhat.com>
References: <200905050909.58583.mark.langsdorf@amd.com>
	 <200905071000.14038.mark.langsdorf@amd.com>
	 <200905081203.55484.mark.langsdorf@amd.com>
	 <200905191356.37071.mark.langsdorf@amd.com>
	 <1242806386.26820.549.camel@twins>  <4A13C199.5020400@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 20 May 2009 10:42:34 +0200
Message-Id: <1242808954.26820.556.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-20 at 11:38 +0300, Avi Kivity wrote:
> Peter Zijlstra wrote:
> > That said, I still thoroughly dislike this whole approach.
> >   
> 
> Can you explain why?  We have a thread that has detected that it's 
> spinning.  Keeping on spinning is a waste of cpu time.  Why not let 
> something else use the cpu?

Because its a polling interface. I much prefer it if we were to get a
wakeup notification when the vcpu holding the lock releases it.
