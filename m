Return-Path: <linux-kernel-owner+w=401wt.eu-S1760362AbXIOGkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760362AbXIOGkh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 02:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbXIOGka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 02:40:30 -0400
Received: from depni.sinp.msu.ru ([213.131.7.21]:49118 "EHLO depni.sinp.msu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827AbXIOGka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 02:40:30 -0400
To: Andi Kleen <ak@suse.de>
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: x86_64: Remove unnecessary cast in prefetch()
References: <87tzq7cwnt.fsf@depni.sinp.msu.ru> <200709070818.03995.ak@suse.de>
From: Serge Belyshev <belyshev@depni.sinp.msu.ru>
Date: Sat, 15 Sep 2007 10:40:26 +0400
In-Reply-To: <200709070818.03995.ak@suse.de> (Andi Kleen's message of "Fri\, 7 Sep 2007 08\:18\:03 +0100")
Message-ID: <878x78ig85.fsf@depni.sinp.msu.ru>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/23.0.0 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <ak@suse.de> writes:

>> This can be fixed better by using gcc's __builtin_prefetch().
>
> I changed it to just use that. Thanks.
>
> It seems like gcc 3.1/3.2 already supported it and that's the earliest gcc
> still supported so it can be used unconditionally.
>

Hi!

Will you submit this patch for inclusion into 2.6.23?  It is important
to make kernel work with GCC 4.3 and above.  (Also note that gcc 4.2 already
smart enough to break that code, but kernel is just lucky currently).
