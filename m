Return-Path: <linux-kernel-owner+w=401wt.eu-S1752096AbZKJKzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbZKJKzt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 05:55:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbZKJKzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 05:55:48 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56915 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751034AbZKJKzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 05:55:48 -0500
Date: Tue, 10 Nov 2009 10:56:42 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Avi Kivity <avi@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Willy Tarreau <w@1wt.eu>,
       Pavel Machek <pavel@ucw.cz>, Matteo Croce <technoboy85@gmail.com>,
       Sven-Haegar Koch <haegar@sdinet.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091110105642.215804e0@lxorguk.ukuu.org.uk>
In-Reply-To: <4AF9435F.2070103@redhat.com>
References: <4AF4526B.4060101@zytor.com>
	<40101cc30911061418w357b74d8i3bf9a9537de052d4@mail.gmail.com>
	<20091108173708.GF1372@ucw.cz>
	<40101cc30911080940s18eb26bbg641beeaddbc25c3d@mail.gmail.com>
	<20091108181016.GB32364@elf.ucw.cz>
	<alpine.DEB.2.00.0911082026430.30789@aurora.sdinet.de>
	<20091108193618.GB4186@elf.ucw.cz>
	<40101cc30911081147j77f7b81o86f2cc5a869aca1f@mail.gmail.com>
	<20091108195158.GD4186@elf.ucw.cz>
	<20091108200852.7f2cf092@lxorguk.ukuu.org.uk>
	<20091110052711.GA15338@1wt.eu>
	<4AF9020C.90108@zytor.com>
	<4AF9435F.2070103@redhat.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In theory yes.  There would need to be a bit of work to disassociate it 
> from kvm, but nothing too difficult.

For the tiny cases that actually matter using the KVM code appears a bit
over the top.
