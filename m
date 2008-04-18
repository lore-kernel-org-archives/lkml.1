Return-Path: <linux-kernel-owner+w=401wt.eu-S1755119AbYDRP7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119AbYDRP7H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 11:59:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbYDRP6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 11:58:53 -0400
Received: from ZSM1387.piap.pl ([195.187.100.11]:50972 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904AbYDRP6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 11:58:52 -0400
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jeff Garzik <jeff@garzik.org>,
       <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2] Re: WAN: new PPP code for generic HDLC
References: <m3prtzsszg.fsf@maximus.localdomain>
	<m3tzj92xq6.fsf@maximus.localdomain>
	<m33aqedg0a.fsf@maximus.localdomain>
	<m37if4oz1g.fsf@maximus.localdomain>
	<20080411221448.22b69ff5.akpm@linux-foundation.org>
	<m3prsva3y7.fsf@maximus.localdomain> <20080412115950.1cbb9cfa@core>
	<m33apqomgf.fsf@maximus.localdomain>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Fri, 18 Apr 2008 17:58:48 +0200
In-Reply-To: <m33apqomgf.fsf@maximus.localdomain> (Krzysztof Halasa's message of "Sat\, 12 Apr 2008 22\:19\:28 +0200")
Message-ID: <m33apjp32f.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update:

> Yes, I could add another dirty "interface fix" to the HDLC + syncppp
> combo (hdlc_ppp), but I don't really see a sense, especially that I
> have the new implementation ready and working (my time resources are
> currently quite limited and if I have to choose between adding another
> glue fix and writing a better PPP replacement I pick the latter).
>
>
> My original post: http://lkml.org/lkml/2008/3/12/277

David doesn't want the new PPP, insisting that I fix existing
hdlc_ppp.c + syncppp.c combo instead, and that there are related bugs
in drivers using syncppp.c alone (not hdlc_ppp) which I have to fix as
well.

Unfortunately I'm unable to do that. Even if I could add another
workaround to hdlc_ppp to make it work with syncppp.c again, I can't
fix the other drivers (if they are indeed broken) because of lack of
hardware, and I can't really make significant changes to syncppp.c
(to make them available to all drivers) because that could and would
break those drivers.

Comments?
-- 
Krzysztof Halasa
