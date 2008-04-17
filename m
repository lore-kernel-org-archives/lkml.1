Return-Path: <linux-kernel-owner+w=401wt.eu-S932622AbYDQKlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932622AbYDQKlg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 06:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752966AbYDQKl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 06:41:28 -0400
Received: from rv-out-0708.google.com ([209.85.198.247]:25003 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752758AbYDQKl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 06:41:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ETqGMLr6t16CrHNjfE9eKg0bhLWJl8UOJ1H93ZRN1lR5moxKgq1a8AQtr+3CJ0D/jIRbYCeWbnNKJc9KVe45UjtWU+iGUuC0vtE9NgplpNl+o7fSGQar8pcB7XDY6pYVFDpF42C3fsTZEHF9uwTmQM+zcNb/9huBFuSvCYKwSic=
Message-ID: <84144f020804170341x44b3ac90h4fbfd193939af945@mail.gmail.com>
Date: Thu, 17 Apr 2008 13:41:26 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Vegard Nossum" <vegard.nossum@gmail.com>
In-Reply-To: <20080417033333.947dfcc9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080416202338.GA6007@elte.hu>
	 <20080417002552.5742ad65.akpm@linux-foundation.org>
	 <20080417083000.GA4935@elte.hu>
	 <20080417014054.ea788f1f.akpm@linux-foundation.org>
	 <20080417090626.GA14383@elte.hu>
	 <20080417021813.04df7912.akpm@linux-foundation.org>
	 <20080417093025.GA17389@elte.hu>
	 <20080417023603.672d1032.akpm@linux-foundation.org>
	 <84144f020804170319g6e0b90ffq1c42179e084d18f@mail.gmail.com>
	 <20080417033333.947dfcc9.akpm@linux-foundation.org>
X-Google-Sender-Auth: b8e34e51146998ab
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Thu, Apr 17, 2008 at 1:33 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>  Thank you whoever wrote kmemcheck.txt

That would be Vegard.

On Thu, Apr 17, 2008 at 1:33 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>  How come slub uses one byte to track the status of each byte when it could
>  use a single bit?

Single bit is not enough as we track use after free as well (after
we've added delayed freeing to the beast).

On Thu, Apr 17, 2008 at 1:33 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>  We (still!) have not made the decision whether to proceed with slab or
>  slub.  How hard would it be to port kmemcheck into slab?

Not hard.
