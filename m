Return-Path: <linux-kernel-owner+w=401wt.eu-S1757084AbZKJQib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084AbZKJQib (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 11:38:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756885AbZKJQib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 11:38:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35815 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756872AbZKJQia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 11:38:30 -0500
Message-ID: <4AF994FA.8010702@zytor.com>
Date: Tue, 10 Nov 2009 08:29:46 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Willy Tarreau <w@1wt.eu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pavel Machek <pavel@ucw.cz>, Matteo Croce <technoboy85@gmail.com>,
       Sven-Haegar Koch <haegar@sdinet.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
References: <4AF4526B.4060101@zytor.com> <40101cc30911061418w357b74d8i3bf9a9537de052d4@mail.gmail.com> <20091108173708.GF1372@ucw.cz> <40101cc30911080940s18eb26bbg641beeaddbc25c3d@mail.gmail.com> <20091108181016.GB32364@elf.ucw.cz> <alpine.DEB.2.00.0911082026430.30789@aurora.sdinet.de> <20091108193618.GB4186@elf.ucw.cz> <40101cc30911081147j77f7b81o86f2cc5a869aca1f@mail.gmail.com> <20091108195158.GD4186@elf.ucw.cz> <20091108200852.7f2cf092@lxorguk.ukuu.org.uk> <20091110052711.GA15338@1wt.eu> <4AF9020C.90108@zytor.com> <4AF9435F.2070103@redhat.com>
In-Reply-To: <4AF9435F.2070103@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2009 02:41 AM, Avi Kivity wrote:
> 
> In theory yes.  There would need to be a bit of work to disassociate it
> from kvm, but nothing too difficult.
> 
> Note that the kvm x86 emulator is more general than need be (emulates
> real mode code and cpl 0 instructions) and less general than needed
> (many instructions are not emulated, for example nopl).
> 

Yes, but I suspect that adding new instructions probably is
straightforward.  I would still prefer to have a single interpreter in
the kernel as opposed to two different ones which are going to have
different bugs.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

