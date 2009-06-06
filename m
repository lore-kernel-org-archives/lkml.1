Return-Path: <linux-kernel-owner+w=401wt.eu-S1754073AbZFFWCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbZFFWCJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 18:02:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752442AbZFFWB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 18:01:57 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34407 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751721AbZFFWB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 18:01:57 -0400
Date: Sat, 6 Jun 2009 23:03:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Mitchell <jeffrey.mitchell@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Panic early in boot
Message-ID: <20090606230312.0904d0cd@lxorguk.ukuu.org.uk>
In-Reply-To: <9599edfc0906060935q716993f4w7c61e8e9c1dad03e@mail.gmail.com>
References: <9599edfc0906051439s7e006edcrdb68ccde60d51815@mail.gmail.com>
	<4A2A3961.3030504@gmail.com>
	<9599edfc0906060935q716993f4w7c61e8e9c1dad03e@mail.gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Jun 2009 12:35:33 -0400
Jeff Mitchell <jeffrey.mitchell@gmail.com> wrote:

> > Don't worry to append a link to the screenshot next time ;).
> 
> Done...  http://tinypic.com/r/2vuwz1j/5
> 
> > Looks like dmi_string_nosave gets a mess. It tries to dereference
> > 0xffffffffeff44003d. Could you investigate to which save_indent in
> > dmi_decode does the dmi_decode+0x72 correspond to?

The dmi code isn't robust against corrupt BIOS DMI tables. I have a patch
pending for this if you want to try it out. I've no idea if that is the
trigger in your case but it may be.

