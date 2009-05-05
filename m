Return-Path: <linux-kernel-owner+w=401wt.eu-S1757125AbZEEUdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125AbZEEUdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 16:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754128AbZEEUc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 16:32:59 -0400
Received: from outbound-mail-116.bluehost.com ([69.89.22.16]:52758 "HELO
	outbound-mail-116.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753694AbZEEUc6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 16:32:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=lmZr3E/Ybpq2LzT3TEFn+hp3ghKt1BC2Y6sEalhE9TxBGpnUPRXqXKTmcpASHgbP0Tkqo0WHgEnl1SDlDoJVpdjdegQ2wiOypKWgg8BvYTtxmm7C8Xpxs23MIcdY33El;
Date: Tue, 5 May 2009 13:32:54 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ed Swierk <eswierk@aristanetworks.com>
Cc: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org, lenb@kernel.org,
       linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [RFC] [PATCH] PCI mmconfig without ACPI
Message-ID: <20090505133254.2dfc1937@hobbes>
In-Reply-To: <9ae48b020905051309h14cf1d7au175e19c66137555@mail.gmail.com>
References: <1233766786.16414.26.camel@localhost.localdomain>
	<20090204181738.GA16174@elte.hu>
	<1234812741.28801.4.camel@localhost.localdomain>
	<20090505105744.4268e341@hobbes>
	<9ae48b020905051309h14cf1d7au175e19c66137555@mail.gmail.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 May 2009 13:09:30 -0700
Ed Swierk <eswierk@aristanetworks.com> wrote:

> On Tue, May 5, 2009 at 10:57 AM, Jesse Barnes
> <jbarnes@virtuousgeek.org> wrote:
> > I'm still a bit dubious about this; does it solve a real issue?  Or
> > just remove the ACPI dependency for its own sake?
> 
> Our products run Linux with a non-ACPI BIOS (Coreboot), so this is not
> just a theoretical issue.

Ah of course, Coreboot.  The patch will need a lot of testing though;
care to send me an updated version so we can get it into linux-next and
have some people try it out?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
