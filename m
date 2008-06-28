Return-Path: <linux-kernel-owner+w=401wt.eu-S1754923AbYF1GWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923AbYF1GWn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 02:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753920AbYF1GWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 02:22:33 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:57942 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884AbYF1GWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 02:22:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Z7/Mi8FgNdFDoyWeBkYyDz+RGwVQOCAQB6chcwNofZi/zjWK4XWiw5TFSkOf7RxiC+
         M1m363e/ppPts6B+TQlHWYXoi3MVCvBa7HXD3+a6MQTYMfje9PTtg+Wvk4nSCLnNQTaR
         Mgd8KJZx1kSqWBIssqQbhkcz0uHHgPKevN1Vc=
Date: Sat, 28 Jun 2008 10:22:01 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/3] Fix copy_user on x86_64
Message-ID: <20080628062201.GA7026@cvg>
References: <m3k5gazh07.fsf@gravicappa.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3k5gazh07.fsf@gravicappa.englab.brq.redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Vitaly Mayatskikh - Fri, Jun 27, 2008 at 11:48:24PM +0200]
| I've moved functionality of copy_user_64.S and copy_user_nocache_64.S to
| copy_user_64.c. Tail handling is now in plain C routine.
| 
| copy_user_generic_string, copy_user_generic_unrolled and
| __copy_user_nocache were tested by me with a bit modified systemtap's
| script which was in attach in my previous letter.
| -- 
| wbr, Vitaly
| 

Hi Vitaly, actually I don't see quite benefit from 'wrapping'
assembler code by C. At least it was more readable before. Sorry.
But lets wait for another optinions. Maybe I'm just too hypercritical ;)

A few Cc added.

		- Cyrill -
