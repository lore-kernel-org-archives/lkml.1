Return-Path: <linux-kernel-owner+w=401wt.eu-S1756667AbZJ0TMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667AbZJ0TMF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 15:12:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756616AbZJ0TME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 15:12:04 -0400
Received: from claw.goop.org ([74.207.240.146]:43033 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756551AbZJ0TMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 15:12:03 -0400
Message-ID: <4AE74606.9050309@goop.org>
Date: Tue, 27 Oct 2009 12:12:06 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Christian Kujau <lists@nerdbynature.de>
CC: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       torvalds@linux-foundation.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.32-rc not booting with Xen-3.2 (bisected)
References: <alpine.DEB.2.01.0910261445170.9408@bogon.housecafe.de> <alpine.DEB.2.01.0910261513520.9408@bogon.housecafe.de> <4AE628DB.5010305@goop.org> <alpine.DEB.2.01.0910261759470.9408@bogon.housecafe.de> <alpine.DEB.2.01.0910261820050.9408@bogon.housecafe.de> <4AE67506.2040200@goop.org> <alpine.DEB.2.01.0910262154410.9408@bogon.housecafe.de> <4AE73973.3070709@goop.org> <alpine.DEB.2.01.0910271158100.9408@bogon.housecafe.de>
In-Reply-To: <alpine.DEB.2.01.0910271158100.9408@bogon.housecafe.de>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/09 12:01, Christian Kujau wrote:
> On Tue, 27 Oct 2009 at 11:18, Jeremy Fitzhardinge wrote:
>   
>> $ gdb vmlinux
>> (gdb) x/i 0xffffffff812c50ad
>>     
> The value is always ffffffff812c50ad, gdb says:
>
> (gdb) x/i 0xffffffff812c50ad
> 0xffffffff812c50ad <xen_load_gdt_boot+252>:     ud2a  
>   

OK, I can repro this here and I'm looking into it.   This particular
crash has been reported before on other kernels, but it seems more
easily triggered in this kernel.

    J
