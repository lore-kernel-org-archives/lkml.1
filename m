Return-Path: <linux-kernel-owner+w=401wt.eu-S1756941AbZAVTE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941AbZAVTE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 14:04:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754926AbZAVTER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 14:04:17 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38607 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754916AbZAVTEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 14:04:16 -0500
Date: Thu, 22 Jan 2009 19:04:32 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Risto Suominen <risto.suominen@gmail.com>
Cc: adaplas@pol.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vt - fb: hide cursor in graphics mode
Message-ID: <20090122190432.55696781@lxorguk.ukuu.org.uk>
In-Reply-To: <46e1c7760901221023r2766a57ey4564d05c05751b6e@mail.gmail.com>
References: <46e1c7760901221023r2766a57ey4564d05c05751b6e@mail.gmail.com>
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

On Thu, 22 Jan 2009 20:23:05 +0200
Risto Suominen <risto.suominen@gmail.com> wrote:

> Xserver Xfbdev (kdrive) uses linux framebuffer in graphics mode. It doesn't
> need the text mode cursor, it's a bit annoying to have it there sitting in a
> corner. This patch disables the cursor when switching to graphics mode.
> 
> Signed-off-by: Risto Suominen <Risto.Suominen@gmail.com>

NAK. You need to work out what your real problem is I think. When we
enter graphics mode we hide the cursor automatically and always have done.

See set_cursor() and also do_blank_screen(1)



