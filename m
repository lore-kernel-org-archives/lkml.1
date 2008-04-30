Return-Path: <linux-kernel-owner+w=401wt.eu-S1760205AbYD3RDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760205AbYD3RDB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 13:03:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758034AbYD3RCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 13:02:50 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45629 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758001AbYD3RCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 13:02:49 -0400
Date: Wed, 30 Apr 2008 17:55:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Fabio De Francesco <fabiomdf@alice.it>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [x86_32] With 4GB installed, in which cases low mem total is
 less than 896MB?
Message-ID: <20080430175510.2ad08f61@core>
In-Reply-To: <200804301702.06019.fabiomdf@alice.it>
References: <200804301702.06019.fabiomdf@alice.it>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why is it needed to activate the PAE mechanism in order to see and use the whole 4GB memory? Is it what it is expected to be done?
> 
> Thanks in advance to anyone who will reply.

The PCI hole has to be below 4GB so the Intel chipset maps some RAM above
4GB where PAE is needed to address it.
