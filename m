Return-Path: <linux-kernel-owner+w=401wt.eu-S1751011AbZKLG7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751011AbZKLG7o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 01:59:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750763AbZKLG7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 01:59:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55843 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbZKLG7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 01:59:42 -0500
Date: Thu, 12 Nov 2009 07:59:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Dave Jones <davej@codemonkey.org.uk>
Subject: Re: [PATCH RFC] x86: fix confusing name of /proc/cpuinfo "ht" flag
Message-ID: <20091112065930.GA9279@elte.hu>
References: <200911112134.34261.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911112134.34261.bzolnier@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> "ht" flag indicates only ability to detect siblings not HT presence 
> itself.
> 
> Inspired by:
> http://www.codemonkey.org.uk/2009/11/10/common-hyperthreading-misconception/

i think instead of changing 'ht' to 'ht_detect', it would be even more 
intuitive to only expose the 'ht' flag if the ht-detect capability is 
there _and_ if the number of siblings is 2 or more.

That way we dont change it - we just 'hide' the 'ht' string on the 
category of systems that can enumerate HT via the CPUID but dont 
actually have HyperThreading.

Hm?

	Ingo
