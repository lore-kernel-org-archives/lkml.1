Return-Path: <linux-kernel-owner+w=401wt.eu-S1755006AbYHHL3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006AbYHHL3T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 07:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754648AbYHHL3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 07:29:10 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43265 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598AbYHHL3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 07:29:09 -0400
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: david@lang.hm, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: why are namespaces required?
From: Andi Kleen <andi@firstfloor.org>
References: <alpine.DEB.1.10.0808071752210.892@asgard.lang.hm>
	<20080808013304.GA27778@martell.zuzino.mipt.ru>
Date: Fri, 08 Aug 2008 13:29:06 +0200
In-Reply-To: <20080808013304.GA27778@martell.zuzino.mipt.ru> (Alexey Dobriyan's message of "Fri, 8 Aug 2008 05:33:04 +0400")
Message-ID: <87ej4z4uf1.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan <adobriyan@gmail.com> writes:
>
> And while we're at it, data from my usual config adding _NS options
> one-by-one.
>
> 	$ size vmlinux-000 vmlinux-uts-ns vmlinux-ipc-ns vmlinux-user-ns vmlinux-pid-ns 
> 	   text    data     bss     dec     hex filename
> 	2560804  217296  225280 3003380  2dd3f4 vmlinux-000
> 	2560948  217296  225280 3003524  2dd484 vmlinux-uts-ns	(+144)
> 	2561452  217296  225280 3004028  2dd67c vmlinux-ipc-ns	(+504)
> 	2561805  217296  225280 3004381  2dd7dd vmlinux-user-ns	(+353)
> 	2562819  217300  225280 3005399  2ddbd7 vmlinux-pid-ns	(+1018)
>
> What amazing .text savings we have here.

Fully agreed. Probably a lot of these CONFIG options should be just dropped.
They are quite user unfriendly with very little gain.

It seems like there is unbounded growth in different name space options
which also implies unbounded CONFIG growth. At least they should be all
consolidated into a single CONFIG.

-Andi

