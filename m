Return-Path: <linux-kernel-owner+w=401wt.eu-S1752631AbZKQRdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbZKQRdo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 12:33:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbZKQRdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 12:33:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44369 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbZKQRdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 12:33:43 -0500
Message-ID: <4B02DE4E.4070504@zytor.com>
Date: Tue, 17 Nov 2009 09:33:02 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: Valdis.Kletnieks@vt.edu, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pavel Machek <pavel@ucw.cz>, Matteo Croce <technoboy85@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
References: <4AF886D4.1080108@zytor.com> <20091109212333.GE15159@caffeine.csclub.uwaterloo.ca> <20091112121805.GF1394@ucw.cz> <20091113162301.GU15157@caffeine.csclub.uwaterloo.ca> <20091113165730.0b9b2676@lxorguk.ukuu.org.uk> <20091113192412.GY15157@caffeine.csclub.uwaterloo.ca> <20091113212148.5cb829d4@lxorguk.ukuu.org.uk> <20091116175006.GA15157@caffeine.csclub.uwaterloo.ca> <20091117115929.4ba23c49@lxorguk.ukuu.org.uk> <7332.1258476527@turing-police.cc.vt.edu> <20091117172515.GI15159@caffeine.csclub.uwaterloo.ca>
In-Reply-To: <20091117172515.GI15159@caffeine.csclub.uwaterloo.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2009 09:25 AM, Lennart Sorensen wrote:
> On Tue, Nov 17, 2009 at 11:48:47AM -0500, Valdis.Kletnieks@vt.edu wrote:
>> Umm...  'modprobe msr'?
>>
>> (Recently I had what *looked* like an xorg server bug, turned out to be a
>> missing CONFIG_INPUT_EVDEV.. Whoops. ;)
> 
> I did.  Makes no difference.  If I unload it I get the same error.
> 
> # modinfo msr
> filename:       /lib/modules/2.6.26-2-gx1/kernel/arch/x86/kernel/msr.ko
> author:         H. Peter Anvin <hpa@zytor.com>
> description:    x86 generic MSR driver
> license:        GPL
> vermagic:       2.6.26-2-gx1 mod_unload GEODEGX1
> depends:
> 
> # lsmod |grep msr
> msr                     2692  0
> 
> I don't get it.
> 

Does /dev/cpu/*/msr exist?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

