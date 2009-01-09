Return-Path: <linux-kernel-owner+w=401wt.eu-S1758304AbZAIVgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758304AbZAIVgl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 16:36:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbZAIVga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 16:36:30 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60851 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754760AbZAIVg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 16:36:29 -0500
Date: Fri, 9 Jan 2009 21:35:55 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       dmitry.torokhov@gmail.com, linux-input@vger.kernel.org
Subject: Re: Re (hello?): [PATCH] Let keyboard notifiers modify key codes
Message-ID: <20090109213555.7f9275c9@lxorguk.ukuu.org.uk>
In-Reply-To: <20090109212358.GG5073@const.famille.thibault.fr>
References: <20090107005813.GA4987@const.famille.thibault.fr>
	<20090109212358.GG5073@const.famille.thibault.fr>
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

On Fri, 9 Jan 2009 22:23:58 +0100
Samuel Thibault <samuel.thibault@ens-lyon.org> wrote:

> Hello,
> 
> Came somebody have a look at this?  The need is real, the only question
> that comes to my mind is whether notifiers are allowed to modify the
> param they are given.  Since they are not marked const, I'd guess it'd
> be ok?

The notifier code doesn't care.

> Make kbd_keycode() read param.value after calling the keyboard notification
> chain, to let the callee change the translation on the fly. This for instance
> permits to remap the physical positions of the keys independently of the
> configured keymap, for e.g. single-handed people.

Surely that is just a new keymap ?

