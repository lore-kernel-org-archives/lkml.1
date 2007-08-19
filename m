Return-Path: <linux-kernel-owner+w=401wt.eu-S1754807AbXHSOs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbXHSOs4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 10:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbXHSOsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 10:48:47 -0400
Received: from aa013msr.fastwebnet.it ([85.18.95.73]:36367 "EHLO
	aa013msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbXHSOsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 10:48:47 -0400
Date: Sun, 19 Aug 2007 16:48:35 +0200
From: Paolo Ornati <ornati@fastwebnet.it>
To: Marc Perkel <mperkel@yahoo.com>
Cc: Willy Tarreau <w@1wt.eu>, Jiri Slaby <jirislaby@gmail.com>,
       Marc Perkel <mperkel@yahoo.com>, linux-kernel@vger.kernel.org
Subject: Re: The vi editor causes brain damage
Message-ID: <20070819164835.010f0e5b@localhost>
In-Reply-To: <952949.96475.qm@web52503.mail.re2.yahoo.com>
References: <20070819072135.GQ6002@1wt.eu>
	<952949.96475.qm@web52503.mail.re2.yahoo.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Aug 2007 06:22:37 -0700 (PDT)
Marc Perkel <mperkel@yahoo.com> wrote:

> 20 years, a million programmers, tens of millions of
> users and RM is BROKEN. Am I the only one who has a
> problem with this? If so - I'm normal - and Linux is a
> cult.


Fixed in 2.6.23-rc (and not just for "rm"):

commit b6a2fea39318e43fee84fa7b0b90d68bed92d2ba
Author: Ollie Wild <aaw@google.com>
Date:   Thu Jul 19 01:48:16 2007 -0700

    mm: variable length argument support

    Remove the arg+env limit of MAX_ARG_PAGES by copying the strings
    directly from the old mm into the new mm.
[...]

-- 
	Paolo Ornati
	Linux 2.6.23-rc3-g2a677896-dirty on x86_64
