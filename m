Return-Path: <linux-kernel-owner+w=401wt.eu-S1758845AbZAIWCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758845AbZAIWCe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 17:02:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757782AbZAIWCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 17:02:19 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40100 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754128AbZAIWCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 17:02:18 -0500
Date: Fri, 9 Jan 2009 22:01:44 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       dmitry.torokhov@gmail.com, linux-input@vger.kernel.org
Subject: Re: Re (hello?): [PATCH] Let keyboard notifiers modify key codes
Message-ID: <20090109220144.6b99ed72@lxorguk.ukuu.org.uk>
In-Reply-To: <20090109214357.GH5073@const.famille.thibault.fr>
References: <20090107005813.GA4987@const.famille.thibault.fr>
	<20090109212358.GG5073@const.famille.thibault.fr>
	<20090109213555.7f9275c9@lxorguk.ukuu.org.uk>
	<20090109214357.GH5073@const.famille.thibault.fr>
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

> > Surely that is just a new keymap ?
> 
> No. That would mean a lot of keymapSSS. Doing it the keymap way

Why - its an  algorithmic question about how to edit them - remember you
can edit keymaps in programs at runtime and live.

> This really is a problem that is orthogonal to keymaps: I'm here talking
> about _physical_ keys remapping, not remapping what is printed on them
> (which is done after that).

Ok so this is analogous to the X key remapping. In which case a notifier
seems as sane as any other way to perform the action if you want it to be
an add on loadable feature.
