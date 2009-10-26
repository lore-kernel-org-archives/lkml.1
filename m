Return-Path: <linux-kernel-owner+w=401wt.eu-S1754852AbZJZTOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbZJZTOB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 15:14:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170AbZJZTOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 15:14:00 -0400
Received: from claw.goop.org ([74.207.240.146]:34426 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918AbZJZTOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 15:14:00 -0400
Message-ID: <4AE5F4FB.3000506@goop.org>
Date: Mon, 26 Oct 2009 12:14:03 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "Ryan C. Gordon" <icculus@icculus.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 2/2] binfmt_elf: FatELF support for kernel modules.
References: <alpine.DEB.2.00.0910190422090.13303@andre.icculuslan>	<4ADD0086.9060304@goop.org>	<alpine.DEB.2.00.0910200043200.18342@andre.icculuslan>	<4AE22D04.50708@goop.org> <20091024121421.2e530635@lxorguk.ukuu.org.uk>
In-Reply-To: <20091024121421.2e530635@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/09 04:14, Alan Cox wrote:
>> Well, ideally a fat module would allow modules for multiple kernels to
>> be bundled together (same and/or different architectures), which is
>> primarily useful for 3rd-party binary distributions.
>>     
> You would need thousands and thousands of binaries to do that. I'm not
> sure the gigabyte sized module file would be too popular. It would be
> easier to recompile it even automatically (take a look at the Dell stuff
> for this)
>   

Yeah, I should have been a bit clearer here.  My point was that if this
facility were to exist, it would seem logical to support that kind of
mode of operation (since at least at one point vendors shipping binary
modules would seem to include a few enterprise distro builds and hope
that would cover it).  But that doesn't seem like a very good idea.

Auto-building schemes are better, but they still always seem to break.

    J

