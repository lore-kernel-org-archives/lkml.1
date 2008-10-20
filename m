Return-Path: <linux-kernel-owner+w=401wt.eu-S1754394AbYJTTGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394AbYJTTGF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 15:06:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbYJTTFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 15:05:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48779 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbYJTTFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 15:05:53 -0400
Message-ID: <48FCD585.4050107@zytor.com>
Date: Mon, 20 Oct 2008 12:01:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@eu.citrix.com>
CC: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>, maluta_tiago@yahoo.com.br,
       lguest@ozlabs.org, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [Lguest] lguest: unhandled trap
References: <713731.28571.qm@web50701.mail.re2.yahoo.com>	 <200810201452.04932.rusty@rustcorp.com.au> <20081020072236.GD12131@elte.hu>	 <48FC36B9.6000704@goop.org>  <20081020075333.GC798@elte.hu> <1224494055.9053.192.camel@zakaz.uk.xensource.com>
In-Reply-To: <1224494055.9053.192.camel@zakaz.uk.xensource.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell wrote:
> 
> Wasn't there some concern about BIOSes which don't correctly reserve
> their DMI tables? Or don't even have e820 maps? H. Peter once said:
> 
>> It's pretty standard for 0xf0000...0x100000 to be marked RESERVED in
>> E820 on real hardware (including the system I'm typing on right now.)
>> It is so marked to indicate that hardware cannot be mapped into that
>> space.  However, you can't rely on this fact -- heck, you can't rely on
>> E820 even existing on a real machine.  I have specimens of real-life
>> machines that go both ways.
> 

Not only that, but the ACPI spec states explicitly that the ISA magic 
areas should be handled without relying on E820.

	-hpa
