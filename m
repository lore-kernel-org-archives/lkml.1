Return-Path: <linux-kernel-owner+w=401wt.eu-S1753864AbXIOVQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbXIOVQ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 17:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbXIOVQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 17:16:20 -0400
Received: from depni.sinp.msu.ru ([213.131.7.21]:56568 "EHLO depni.sinp.msu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329AbXIOVQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 17:16:19 -0400
To: Andi Kleen <andi@firstfloor.org>
Cc: Andi Kleen <ak@suse.de>, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: x86_64: Remove unnecessary cast in prefetch()
References: <87tzq7cwnt.fsf@depni.sinp.msu.ru> <200709070818.03995.ak@suse.de>
	<878x78ig85.fsf@depni.sinp.msu.ru>
	<20070915200117.GC14501@one.firstfloor.org>
From: Serge Belyshev <belyshev@depni.sinp.msu.ru>
Date: Sun, 16 Sep 2007 01:16:18 +0400
In-Reply-To: <20070915200117.GC14501@one.firstfloor.org> (Andi Kleen's message of "Sat\, 15 Sep 2007 22\:01\:17 +0200")
Message-ID: <87ejgziq8t.fsf@depni.sinp.msu.ru>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/23.0.0 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

...
>> to make kernel work with GCC 4.3 and above.  (Also note that gcc 4.2 already
>> smart enough to break that code, but kernel is just lucky currently).
>
> How would it break the code exactly?  It more sounded like an optimization
> to me. Would it generate incorrect code without it?


See http://gcc.gnu.org/PR33294 for testcase which fails if compiled with gcc 4.2
and above.  Yes, incorrect code can be generated without the patch as demonstrated by
testcase, but i didn't analyze why kernel appears to work with 4.2 currently.
