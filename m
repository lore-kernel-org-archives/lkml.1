Return-Path: <linux-kernel-owner+w=401wt.eu-S1758303AbYHUIBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758303AbYHUIBr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 04:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756636AbYHUIB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 04:01:28 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:31084 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756429AbYHUIB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 04:01:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:x-mailer:mime-version:subject:date:cc;
        b=qIMUsVV6sWuw+pjPl/TptfZHhdU/YDl+XUvj4JVxjscm3hOhasnAbRBtpI0HQhBx4Y
         jbSM2ODrNz7LOMLSszkbVWYR3OUJV12cG1k9uLp8r02TFdP756AykWCAvsVqgqQDaKDt
         dhc0Xj5QyDLmx3WNBP+hurYyAzvLgTU6YiFME=
References: <Pine.LNX.4.64.0808202251500.17436@takamine.ncl.cs.columbia.edu> <Pine.LNX.4.64.0808202304490.17436@takamine.ncl.cs.columbia.edu> <20080821073020.GA28386@elte.hu>
Message-Id: <257F964F-8ECA-4792-9CE6-D081E5E2DE06@gmail.com>
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20080821073020.GA28386@elte.hu>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (5C1)
Mime-Version: 1.0 (iPhone Mail 5C1)
Subject: Re: [RFC v2][PATCH 4/9] Memory management - dump state
Date: Thu, 21 Aug 2008 01:01:21 -0700
Cc: Oren Laadan <orenl@cs.columbia.edu>,
       "dave@linux.vnet.ibm.com" <dave@linux.vnet.ibm.com>,
       "arnd@arndb.de" <arnd@arndb.de>, "jeremy@goop.org" <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_INGO=Y
(sorry saw andrew Morton do that
Couldn't resist);

justin P. Mattock



On Aug 21, 2008, at 12:30 AM, Ingo Molnar <mingo@elte.hu> wrote:

>
> * Oren Laadan <orenl@cs.columbia.edu> wrote:
>
>> checkpoint/ckpt_x86.c   |   28 ++++
>> checkpoint/rstr_x86.c   |    2 +
>
> please move these into arch/x86/mm/checkpoint.c and
> arch/x86/mm/restore.c. (also, please dont try to abbreviate too much  
> in
> filenames, makes it harder to follow changes later on, etc.)
>
> Cool stuff btw! Any ETA on when more complex apps can be
> checkpointed/restored? Also, shouldnt at least part of this effort be
> joined with the live migration efforts of openvz? (or do you see
> fundamental, unsolvable differences?)
>
>    Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
