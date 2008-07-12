Return-Path: <linux-kernel-owner+w=401wt.eu-S1754489AbYGLKy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbYGLKy7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 06:54:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751994AbYGLKyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 06:54:51 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50184 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751044AbYGLKyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 06:54:51 -0400
Date: Sat, 12 Jul 2008 11:37:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Joe Peterson <joe@skyrush.com>
Cc: Elias Oltmanns <eo@nebensachen.de>,
       =?UTF-8?B?VMO2csO2aw==?= Edwin <edwintorok@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Ctrl+C doesn't interrupt process waiting for I/O
Message-ID: <20080712113719.1fe58bf9@lxorguk.ukuu.org.uk>
In-Reply-To: <4877FE5C.3000900@skyrush.com>
References: <48661488.10304@gmail.com>
	<87fxqurqpz.fsf@denkblock.local>
	<486E83C3.1040509@skyrush.com>
	<20080704212335.4ffc8230@lxorguk.ukuu.org.uk>
	<486E9366.2090901@skyrush.com>
	<20080711154748.407ea6c9@lxorguk.ukuu.org.uk>
	<4877FE5C.3000900@skyrush.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In a Linux virtual console/tty, however, the tty driver flush doesn't
> call the ldisc flush again in my tests:

PTY/TTY is a pair - the driver flush of one side causes an ldisc flush of
the other.
