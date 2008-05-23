Return-Path: <linux-kernel-owner+w=401wt.eu-S1758634AbYEWPJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758634AbYEWPJ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 11:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758031AbYEWPJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 11:09:48 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51662 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751600AbYEWPJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 11:09:47 -0400
Date: Fri, 23 May 2008 15:56:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, aoliva@redhat.com,
       Abhay Salunke <Abhay_Salunke@dell.com>, kay.sievers@vrfy.org,
       Haroldo Gamal <gamal@alternex.com.br>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 1/3] firmware: allow firmware files to be built into
 kernel image
Message-ID: <20080523155610.2ec5ffd0@core>
In-Reply-To: <1211550282.28967.8.camel@pmac.infradead.org>
References: <1211550282.28967.8.camel@pmac.infradead.org>
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

> A third set of drivers already use the firmware loader, but can't be
> used without help from userspace, which sometimes requires an initrd.
> This allows them to work in a static kernel.

This makes a lot of sense to me - its small, clean and while I don't
think its relevant to the PC world it has real clear advantages to the
embedded space.

For the embedded case isn't either compressing the firmware or not doing
the vmalloc/copy worth the effort however ?

