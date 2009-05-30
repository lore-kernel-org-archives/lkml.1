Return-Path: <linux-kernel-owner+w=401wt.eu-S1752946AbZE3HMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946AbZE3HMr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 03:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbZE3HMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 03:12:38 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:34472 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbZE3HMi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 03:12:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=hJrkl6Jy3Q1fHdxlPQw2g4UoYQRIQu7N/KfLQ19pbfIe9Mg2OAFPKLE22cyu9OjDEM
         fvOIbApUxToLb+0tOuvlKKpgiNjHpY+TXMtxytPWDgnxCtFKC5oDXYs1y4UstZHXXsW1
         j3Q6T8vDqLEF7L9DYVWSXJlPvGu3JECQLnTnY=
MIME-Version: 1.0
In-Reply-To: <20090529155859.2cf20823.akpm@linux-foundation.org>
References: <20090520183045.GB10547@oblivion.subreption.com>
	 <1242852158.6582.231.camel@laptop>
	 <20090520212413.GF10756@oblivion.subreption.com>
	 <20090529155859.2cf20823.akpm@linux-foundation.org>
Date: Sat, 30 May 2009 10:12:38 +0300
X-Google-Sender-Auth: 3da1dc2b9edf9be3
Message-ID: <84144f020905300012h6ca92605ve8fdcbaba39ac054@mail.gmail.com>
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page 
	allocator
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Larry H." <research@subreption.com>, peterz@infradead.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       linux-mm@kvack.org, mingo@redhat.com, pageexec@freemail.hu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Sat, May 30, 2009 at 1:58 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>  But how to do that?  Particular callsites don't get to alter
>  kfree()'s behaviour.  So they'd need to use a new kfree_sensitive().
>  Which is just syntactic sugar around the code whihc we presently
>  implement.

Unless I am missing something here, we already have kfree_sensitive(),
we just call it kzfree().

                                 Pekka
