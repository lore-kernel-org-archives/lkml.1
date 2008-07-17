Return-Path: <linux-kernel-owner+w=401wt.eu-S933671AbYGQTjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933671AbYGQTjB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 15:39:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760949AbYGQTiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 15:38:04 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:36313 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933270AbYGQTiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 15:38:03 -0400
X-Greylist: delayed 628 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Jul 2008 15:38:02 EDT
Date: Thu, 17 Jul 2008 19:55:01 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Fred ." <eldmannen@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Please add ZFS support (from GPL sources)
Message-ID: <20080717195501.44f90aa3@the-village.bc.nu>
In-Reply-To: <f188924b0807171213q43f10b09j47b34674fc8aaa38@mail.gmail.com>
References: <f188924b0807171213q43f10b09j47b34674fc8aaa38@mail.gmail.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2008 21:13:55 +0200
"Fred ." <eldmannen@gmail.com> wrote:

> Previously we have not been able to have ZFS support due to it being
> licensed under the CDDL and the kernel under the GPL.
> 
> Sun have contributed ZFS support to GRUB under the GPL license. We
> could now use that code to implement support for ZFS in the Linux
> kernel.

No we can't. The GPL ZFS bits don't include the various methods that
would violate the patent so there is no grant. I've several times asked
Sun to simply give permission and they don't even answer. I can only read
the Sun motiviation one way - they want to look open but know that ZFS is
about the only thing that might save Solaris as a product in the data
centre so are not truely prepared to let Linus use it.

This is now further complicated by the fact Sun and NetApp are in
litigation so ZFS is basically "toxic" for the moment and we'd need
permission from both sets of patent holders to proceed.

Alan
