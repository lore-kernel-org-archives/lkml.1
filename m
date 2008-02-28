Return-Path: <linux-kernel-owner+w=401wt.eu-S1762994AbYB1Ual@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762994AbYB1Ual (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 15:30:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752246AbYB1Uab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 15:30:31 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58634 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752791AbYB1Uab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 15:30:31 -0500
Date: Thu, 28 Feb 2008 20:19:26 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Nebojsa Miljanovic <neb@alcatel-lucent.com>
Cc: linux-kernel@vger.kernel.org,
       "Kittlitz, Edward (Ned)" <nkittlitz@alcatel-lucent.com>,
       asweeney@alcatel-lucent.com,
       "Polhemus, William (Bart)" <bpolhemus@alcatel-lucent.com>
Subject: Re: SO_REUSEADDR not allowing server and client to use same port
Message-ID: <20080228201926.558c4e7c@core>
In-Reply-To: <47C6FA2A.5030302@alcatel-lucent.com>
References: <47C6FA2A.5030302@alcatel-lucent.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Currently, Linux does not allow reuse of same local port for both TCP server and
> TCP client. I understand that there may be a need to prevent two servers from

Think about what happens for simultaneous connect (that obscure little
corner of the tcp/ip spec). Now think about what it means for security.

ALan
