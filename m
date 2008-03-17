Return-Path: <linux-kernel-owner+w=401wt.eu-S1754772AbYCQRpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772AbYCQRpW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 13:45:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751413AbYCQRpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 13:45:11 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43446 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752075AbYCQRpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 13:45:10 -0400
Date: Mon, 17 Mar 2008 17:30:21 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Nebojsa Miljanovic <neb@alcatel-lucent.com>
Cc: linux-kernel@vger.kernel.org,
       "Kittlitz, Edward (Ned)" <nkittlitz@alcatel-lucent.com>,
       asweeney@alcatel-lucent.com,
       "Polhemus, William (Bart)" <bpolhemus@alcatel-lucent.com>
Subject: Re: SO_REUSEADDR not allowing server and client to use same port
Message-ID: <20080317173021.28e6fd97@core>
In-Reply-To: <47DE9FB0.5030801@alcatel-lucent.com>
References: <47C6FA2A.5030302@alcatel-lucent.com>
	<20080228201926.558c4e7c@core>
	<47D97DF7.8000702@alcatel-lucent.com>
	<20080315133426.1f48c99c@the-village.bc.nu>
	<47DE9FB0.5030801@alcatel-lucent.com>
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

On Mon, 17 Mar 2008 11:43:28 -0500
Nebojsa Miljanovic <neb@alcatel-lucent.com> wrote:

> Alan,
> thanks. With that additional INFO, I was able to find detailed description of
> this denial of service attack (attached below).
> Just to clarify. Having this port re-use check prevents folks from launching
> this attack as opposed to being victim of it?

Different issue. I can hijack a connection.

Imagine I have a server bound to *.5000, and someone is about to connect.
If on the server box I am able to bind and issue a connect outwards
matching the inbound connection I will get the connection not the server.
