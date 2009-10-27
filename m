Return-Path: <linux-kernel-owner+w=401wt.eu-S1756301AbZJ0Gdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301AbZJ0Gdq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 02:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756155AbZJ0Gdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 02:33:45 -0400
Received: from mailout05.t-online.de ([194.25.134.82]:38768 "EHLO
	mailout05.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755610AbZJ0Gdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 02:33:45 -0400
Message-ID: <4AE69449.6080605@t-online.de>
Date: Tue, 27 Oct 2009 07:33:45 +0100
From: Harald Dunkel <harald.dunkel@t-online.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090923 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.31.4, ps2-to-usb adapter: fourth mouse button not working
References: <1N1EA3-10pOoy0@fwd05.aul.t-online.de> <20091023073730.GB10914@srcf.ucam.org> <4AE2C572.1030209@t-online.de> <20091024091858.GA30614@srcf.ucam.org> <4AE3043A.4060706@t-online.de> <20091024135357.GA1170@srcf.ucam.org> <4AE3336B.8030905@t-online.de> <20091024171925.GA3541@srcf.ucam.org>
In-Reply-To: <20091024171925.GA3541@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: ThzZFQZbghwvNewnGyL46lE+RGqJiaasT+TH6FZgnAkHgqJQV1CoIdnrFJnljjxwr3
X-TOI-MSGID: 8acd2140-7c9c-4b64-a4cf-4dca6f7e373a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/09 19:19, Matthew Garrett wrote:
>
> usbmon will let you dump USB traffic.
>

Sorry for the delay.

This is what I got for pressing mouse buttons 1 to 4 (in this sequence):

ffff88011e462680 2851892632 C Ii:5:002:2 0:8 5 = 01010000 00
ffff88011e462680 2851892646 S Ii:5:002:2 -115:8 5 <
ffff88011e462680 2852236652 C Ii:5:002:2 0:8 5 = 01000000 00
ffff88011e462680 2852236661 S Ii:5:002:2 -115:8 5 <
ffff88011e462680 2853620738 C Ii:5:002:2 0:8 5 = 01020000 00
ffff88011e462680 2853620747 S Ii:5:002:2 -115:8 5 <
ffff88011e462680 2853868753 C Ii:5:002:2 0:8 5 = 01000000 00
ffff88011e462680 2853868761 S Ii:5:002:2 -115:8 5 <
ffff88011e462680 2854524793 C Ii:5:002:2 0:8 5 = 01040000 00
ffff88011e462680 2854524802 S Ii:5:002:2 -115:8 5 <
ffff88011e462680 2854772808 C Ii:5:002:2 0:8 5 = 01000000 00
ffff88011e462680 2854772816 S Ii:5:002:2 -115:8 5 <
ffff88011e462680 2855572857 C Ii:5:002:2 0:8 5 = 01000000 00
ffff88011e462680 2855572863 S Ii:5:002:2 -115:8 5 <
ffff88011e462680 2855892877 C Ii:5:002:2 0:8 5 = 01000000 00
ffff88011e462680 2855892882 S Ii:5:002:2 -115:8 5 <


The last 4 lines are for button 4. AFAICS it does create an event
on the USB line, but there is no special bit set in the bit mask (the
2nd last value on the "C" lines).

Is there some traffic that usbmon doesn't show yet?


Regards

Harri
