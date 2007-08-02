Return-Path: <linux-kernel-owner+w=401wt.eu-S1756546AbXHBCfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546AbXHBCfw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 22:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbXHBCfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 22:35:44 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:35530 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbXHBCfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 22:35:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=e8dqnA/Fr3jjEpW5NL2DsWejXMNktD5/kpzmvgBLggMf7EFQkPWe4QyNB9vxHla7Om2+7dSoANI6FT9oOuvTFIlNQEbjS9czjK8fIXS21jd9vNL3udCiFVv0/7mjvvRspec0fNrTh9lso2lj9Nenopi3nnVjSLTocDmuvNGzW8E=
Message-ID: <75b66ecd0708011935x600fc547j8edbe1ed3092d560@mail.gmail.com>
Date: Wed, 1 Aug 2007 22:35:41 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: SD still better than CFS for 3d ?(was Re: 2.6.23-rc1)
Cc: "Peter Zijlstra" <peterz@infradead.org>,
       "Kasper Sandberg" <lkml@metanurb.dk>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       ck@vds.kolivas.org
In-Reply-To: <20070731085713.GA15136@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
	 <1185536610.502.8.camel@localhost> <20070729170641.GA26220@elte.hu>
	 <1185839164.27166.7.camel@localhost> <1185863461.3092.4.camel@twins>
	 <20070731085713.GA15136@elte.hu>
X-Google-Sender-Auth: 032a1976ea4be868
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/31/07, Ingo Molnar <mingo@elte.hu> wrote:
> Almost all of the Reiser3
> code runs under the BKL, and the only other major kernel infrastructure
> that has BKL dependencies is the TTY code.

Also NFS:

$ grep -rIi lock_kernel kernel-source/linux-2.6.17/fs/nfs/ | wc -l
94

Lee
