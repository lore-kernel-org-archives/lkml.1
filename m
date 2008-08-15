Return-Path: <linux-kernel-owner+w=401wt.eu-S1755857AbYHOKQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857AbYHOKQY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 06:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbYHOKQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 06:16:16 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54162 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751995AbYHOKQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 06:16:15 -0400
Date: Fri, 15 Aug 2008 10:58:47 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Aristeu Rozanski <aris@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       jirislaby@gmail.com
Subject: Re: [PATCH] vt: kill tty->count usage (v2)
Message-ID: <20080815105847.5462746b@lxorguk.ukuu.org.uk>
In-Reply-To: <20080812145812.GH7154@redhat.com>
References: <20080808213625.GK20355@redhat.com>
	<20080808222635.4fe52b51@lxorguk.ukuu.org.uk>
	<20080812145812.GH7154@redhat.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Aug 2008 10:58:12 -0400
Aristeu Rozanski <aris@redhat.com> wrote:

> The commit e0426e6a09954d205da2d674a3d368d2715e3afd fixes a real race but
> still isn't enough to prevent these:
> 
> kobject_add_internal failed for vcs7 with -EEXIST, don't try to register
> things with the same name in the same direc.

Ack this. Will want some tweaking for the ttydev tree as it wants to
switch to using krefs for vc->vc_tty as well now.

Alan
