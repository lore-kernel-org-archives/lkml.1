Return-Path: <linux-kernel-owner+w=401wt.eu-S932764AbZACUU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932764AbZACUU2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 15:20:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759647AbZACUUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 15:20:20 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34512 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759614AbZACUUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 15:20:19 -0500
Date: Sat, 3 Jan 2009 20:19:55 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pavel Machek <pavel@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       mtk.manpages@gmail.com, rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: atomics: document that linux expects certain atomic behaviour
 from unsigned long
Message-ID: <20090103201955.186974bb@lxorguk.ukuu.org.uk>
In-Reply-To: <20090103124400.GA1572@ucw.cz>
References: <20090103124400.GA1572@ucw.cz>
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

On Sat, 3 Jan 2009 13:44:00 +0100
Pavel Machek <pavel@suse.cz> wrote:

> Linux relies on unsigned long to behave like atomic for read/write.

Actually it isn't that simple and this advice shouldn't be given IMHO.

unsigned long is not the same as atomic in several respects including
ordering and caching of the result.

Alan
