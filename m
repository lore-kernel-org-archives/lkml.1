Return-Path: <linux-kernel-owner+w=401wt.eu-S1750827AbXBMQvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750827AbXBMQvc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 11:51:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750832AbXBMQvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 11:51:32 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:58082 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbXBMQvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 11:51:32 -0500
Subject: Re: current git crashes on bootup with pci_iounmap()
From: Kay Sievers <kay.sievers@vrfy.org>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1171382645.23580.29.camel@violet>
References: <1171380714.3829.6.camel@pim.off.vrfy.org>
	 <1171382645.23580.29.camel@violet>
Content-Type: text/plain
Date: Tue, 13 Feb 2007 17:52:04 +0100
Message-Id: <1171385524.3855.2.camel@pim.off.vrfy.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:4ddcc9dd12ba6cf3155e4d81b383efda
X-Provags-ID2: V01U2FsdGVkX18eE67/4LuK0xNETZJhvhSG/LGuxVBVG2FCmeN0aigr6QjOhj/0eGazxdsAgtriV14+jItFJPQkdf/JiV+EkD2562neegz5AJUjFAFQ5wS7zg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-13 at 17:04 +0100, Marcel Holtmann wrote:
> > kernel BUG at lib/iomap.c:254!
> > invalid opcode: 0000 [#1]
> > ...
> > 
> > The screen picture is here:
> >   http://vrfy.org/pci_iounmap.jpg
> > 
> > It's a Thinkpad T43p.
> > 
> > 2.6.20 was working fine.
> > 
> > Commenting out:
> >   IO_COND(addr, /* nothing */, iounmap(addr));
> > in:
> >   lib/iomap.c:254
> > makes at least booting up possible.
> 
> I saw a similar one on my X41. Disabling the AHCI driver made the
> machine booting again.

Hey Marcel,
yeah, that works fine here too.

Thanks,
Kay

