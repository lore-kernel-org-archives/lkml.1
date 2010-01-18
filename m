Return-Path: <linux-kernel-owner+w=401wt.eu-S1754239Ab0ARRgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239Ab0ARRgh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:36:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753723Ab0ARRgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:36:36 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:38848 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951Ab0ARRgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:36:35 -0500
MIME-Version: 1.0
In-Reply-To: <4B4DE58D.10008@petalogix.com>
References: <4B4DE58D.10008@petalogix.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 18 Jan 2010 10:36:07 -0700
X-Google-Sender-Auth: e277fcb81c44f7a6
Message-ID: <fa686aa41001180936p1fd34dd4pdf675583ce5ccd86@mail.gmail.com>
Subject: Re: xilinx-pci driver and pci in general
To: michal.simek@petalogix.com
Cc: linuxppc-dev@ozlabs.org, benh@kernel.crashing.org, thunderbird2k@gmx.net,
       John Williams <john.williams@petalogix.com>,
       Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 8:23 AM, Michal Simek
<michal.simek@petalogix.com> wrote:
> Hi guys,
>
> We (John and partially I) did initial support for pci on Microblaze.
> It is based on powerpc files and almost everything is the same.
> There are some small differences which could be easily removed that's why I
> think that will be good to move that file to any generic location.
> That's why I would like to know your opinion about this step.
> If you don't like or prefer we will add that modified versions to
> arch/microblaze and in future we can merge them and move to any other
> location.
>
> Affected files: xilinx-pci.c, pci_32.c pci-common.c, indirect_pci.c and some
> headers.

My preference is to move the common bits to a common location first,
and then modify to make it suitable for Microblaze also.  I've just
finished doing a bunch of fdt merge work where PowerPC and Microblaze
diverged in subtle ways.  It isn't a whole lot of fun.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
