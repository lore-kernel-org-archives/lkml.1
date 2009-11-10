Return-Path: <linux-kernel-owner+w=401wt.eu-S1751943AbZKJGKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943AbZKJGKT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 01:10:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbZKJGKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 01:10:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33230 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbZKJGKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 01:10:14 -0500
Message-ID: <4AF9020C.90108@zytor.com>
Date: Mon, 09 Nov 2009 22:02:52 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@ucw.cz>,
       Matteo Croce <technoboy85@gmail.com>,
       Sven-Haegar Koch <haegar@sdinet.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>
Subject: Re: i686 quirk for AMD Geode
References: <4AF4526B.4060101@zytor.com> <40101cc30911061418w357b74d8i3bf9a9537de052d4@mail.gmail.com> <20091108173708.GF1372@ucw.cz> <40101cc30911080940s18eb26bbg641beeaddbc25c3d@mail.gmail.com> <20091108181016.GB32364@elf.ucw.cz> <alpine.DEB.2.00.0911082026430.30789@aurora.sdinet.de> <20091108193618.GB4186@elf.ucw.cz> <40101cc30911081147j77f7b81o86f2cc5a869aca1f@mail.gmail.com> <20091108195158.GD4186@elf.ucw.cz> <20091108200852.7f2cf092@lxorguk.ukuu.org.uk> <20091110052711.GA15338@1wt.eu>
In-Reply-To: <20091110052711.GA15338@1wt.eu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2009 09:27 PM, Willy Tarreau wrote:
> 
> Also, I think that if we start adding emulation, a global and per-task
> counter would immensely help to know what processes make intensive use
> of emulation.
> 

Agreed.

My first question would be if the interpreter in KVM can be reused in
any way.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

