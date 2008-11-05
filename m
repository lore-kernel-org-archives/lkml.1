Return-Path: <linux-kernel-owner+w=401wt.eu-S1756043AbYKEQyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043AbYKEQyx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 11:54:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbYKEQyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 11:54:44 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35393 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752726AbYKEQyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 11:54:44 -0500
Date: Wed, 5 Nov 2008 16:54:05 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Hugh Dickins <hugh@veritas.com>
Cc: "Eugene V. Lyubimkin" <jackyf.devel@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Chris Friesen <cfriesen@nortel.com>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>
Subject: Re: mmap: is default non-populating behavior stable?
Message-ID: <20081105165405.777ab502@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.64.0811051613400.21353@blonde.site>
References: <490F73CD.4010705@gmail.com>
	<1225752083.7803.1644.camel@twins>
	<490F8005.9020708@redhat.com>
	<491070B5.2060209@nortel.com>
	<1225814820.7803.1672.camel@twins>
	<20081104162820.644b1487@lxorguk.ukuu.org.uk>
	<49107D98.9080201@gmail.com>
	<Pine.LNX.4.64.0811051613400.21353@blonde.site>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> (Every year or so we do wonder whether to change an extending mremap
> of a MAP_SHARED|MAP_ANONYMOUS object to extend the object itself instead
> of just SIGBUSing on the extension: but I've so far remained conservative
> about that, and Eugene appears to be thinking of more ordinary files.)

Try an mremap of a VM_GROWS* mapping and all the other things of this
nature. I would say our current behaviour is not what might be expected
by users. The extending an object case is just one example of weird
behaviour.

Alan


