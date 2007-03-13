Return-Path: <linux-kernel-owner+w=401wt.eu-S933057AbXCMKPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933057AbXCMKPP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 06:15:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933012AbXCMKPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 06:15:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60809 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753213AbXCMKPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 06:15:13 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200703121650.35699.rgetz@blackfin.uclinux.org> 
References: <200703121650.35699.rgetz@blackfin.uclinux.org>  <3378.1173204813@redhat.com> <29317.1172931029@redhat.com> <12852.1173449522@redhat.com> 
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: Hugh Dickins <hugh@veritas.com>, bryan.wu@analog.com,
       Robin Holt <holt@sgi.com>,
       "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>,
       Andrew Morton <akpm@osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>, haoki@redhat.com,
       Bernd Schmidt <bernds_cb1@t-online.de>
Subject: Re: Move to unshared VMAs in NOMMU mode? 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Tue, 13 Mar 2007 10:14:15 +0000
Message-ID: <1161.1173780855@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robin Getz <rgetz@blackfin.uclinux.org> wrote:

> We (noMMU) folks need to have special code anyway - so why not put it there, 
> and try not to increase memory footprint?

I'd like to have the drivers and filesystems need to know as little as possible
about whether they're working in MMU-mode or NOMMU-mode - for the most part
such knowledge should be unnecessary.  Additionally, I'd rather not put special
case code in the generic parts of the NOMMU code.

David
