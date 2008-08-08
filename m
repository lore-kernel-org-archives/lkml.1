Return-Path: <linux-kernel-owner+w=401wt.eu-S1754655AbYHHPq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655AbYHHPq4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 11:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752514AbYHHPqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 11:46:48 -0400
Received: from khc.piap.pl ([195.187.100.11]:44745 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720AbYHHPqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 11:46:47 -0400
To: "Chris Friesen" <cfriesen@nortel.com>
Cc: Frans Meulenbroeks <fransmeulenbroeks@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: including .c files ?
References: <ac9c93b10808080425p321fac13y72a5b2b4e67ee6a9@mail.gmail.com>
	<m3abfnk296.fsf@maximus.localdomain> <489C60D3.2040201@nortel.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Fri, 08 Aug 2008 17:46:44 +0200
In-Reply-To: <489C60D3.2040201@nortel.com> (Chris Friesen's message of "Fri\, 08 Aug 2008 09\:05\:55 -0600")
Message-ID: <m33alfjyqj.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Chris Friesen" <cfriesen@nortel.com> writes:

>> Doesn't work when you need conditional compilation.
>
> Sure it does...look at all the kernel Makefiles that compile code
> based on whether a config option is set.

Nope, I meant compilation depending on preprocessor variables defined
(or not) by the including file. CONFIG_* and things like make
variables are completely different things.

Imagine a chip driver (library) doing I/O using either MMIO or
inp/outp. The real card driver uses the library and provides
necessary glue code. You can either a) make I/O real function calls,
call using pointers etc. (slow, should be inline), or b) define the
I/O as inline functions or macros and then #include the library.
-- 
Krzysztof Halasa
