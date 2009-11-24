Return-Path: <linux-kernel-owner+w=401wt.eu-S934310AbZKXVwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934310AbZKXVwB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 16:52:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934297AbZKXVwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 16:52:00 -0500
Received: from outbound-mail-117.bluehost.com ([69.89.22.17]:46866 "HELO
	outbound-mail-117.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934295AbZKXVv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 16:51:58 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=YJbVgGilbCLkSLdzQzha4PS8u6ijjprdN91aQb3KWzZoIDfWHnYHUftzQTZmLwONfDu49HiAJ/javKDxwSY+Gb5mLffT2TmOUl1/blf0frd1INUr5VnMmCF2+3lnTlsP;
Date: Tue, 24 Nov 2009 13:52:02 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alex Chiang <achiang@hp.com>
Cc: linux-pci <linux-pci@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/pci: remove early PCI pr_debug statements
Message-ID: <20091124135202.2637c383@jbarnes-piketon>
In-Reply-To: <20091116212113.GF21242@ldl.fc.hp.com>
References: <20091116212113.GF21242@ldl.fc.hp.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Nov 2009 14:21:13 -0700
Alex Chiang <achiang@hp.com> wrote:

> commit db635adc turned -DDEBUG for x86/pci on when CONFIG_PCI_DEBUG
> is set. In general, I agree with that change.
> 
> However, it exposes a bunch of very low level PCI debugging in the
> early x86 path, such as:
> 
> 	0 reading 2 from a: ffff
> 	1 reading 2 from a: ffff
> 	2 reading 2 from a: ffff
> 	3 reading 2 from a: 300
> 	3 reading 2 from 0: 1002
> 	3 reading 2 from 2: 515e
> 
> These statements add a lot of noise to the boot and aren't likely to
> be necessary even when handling random upstream bug reports.
> 
> [In contrast, statements such as these:
> 
> 	pci 0000:02:04.0: found [14e4:164a] class 000200 header type
> 00 pci 0000:02:04.0: reg 10: [mem 0xf8000000-0xf9ffffff 64bit]
> 	pci 0000:02:04.0: reg 30: [mem 0x00000000-0x0001ffff pref]
> 
> are indeed useful when remote debugging users' machines]
> 
> Remove the noisy printks and save electrons everywhere.

Applied, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
