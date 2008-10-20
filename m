Return-Path: <linux-kernel-owner+w=401wt.eu-S1753933AbYJTMrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbYJTMrz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 08:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbYJTMrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 08:47:43 -0400
Received: from mail.gmx.net ([213.165.64.20]:37019 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751830AbYJTMrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 08:47:42 -0400
X-Authenticated: #6028172
X-Provags-ID: V01U2FsdGVkX18+Dnomu38+Ki8UJ9vMpGqAg0NdIO5rCDznHhaarK
	iABWlejq8w6OyO
Message-ID: <48FC7DEC.9060200@gmx.de>
Date: Mon, 20 Oct 2008 14:47:40 +0200
From: Dieter Ries <clip2@gmx.de>
User-Agent: Thunderbird 2.0.0.17 (X11/20081002)
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Dominik Brodowski <linux@dominikbrodowski.net>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       Tomas Winkler <tomasw@gmail.com>
Subject: Re: iwl3945 broken in current git
References: <48FC6C05.6020901@gmx.de>	 <20081020121710.GA3607@isilmar.linta.de>	 (sfid-20081020_141718_690091_E56EF8AB) <1224506010.27899.23.camel@johannes.berg>	 <48FC7B1A.10307@gmx.de> (sfid-20081020_143609_718157_68144039) <1224506366.27899.25.camel@johannes.berg>
In-Reply-To: <1224506366.27899.25.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5600000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Berg schrieb:
> On Mon, 2008-10-20 at 14:35 +0200, Dieter Ries wrote:
>> Johannes Berg schrieb:
>>> On Mon, 2008-10-20 at 14:17 +0200, Dominik Brodowski wrote:
>>>
>>>>> iwl3945: Microcode SW error detected.  Restarting 0x82000008.
>>>>> iwl3945: Error Reply type 0x00000005 cmd REPLY_SCAN_CMD (0x80) seq
>>>>> 0x4416 ser 0x0000004B
>>>>> iwl3945: Can't stop Rx DMA.
>>>> It needs a more recent uCode -- the driver really should scream out loudly
>>>> that the old firmware no longer suffices.
>>> You could try reverting ef224ca2ce55e81acc6c3a74c3e8c00a00941c70, that's
>>> the only commit I can find that seems to be vaguely related to the
>>> problem as Tomas described it. Not that it might not be hidden in some
>>> other commit...
>> The new firmware did it. It works now, but it should really scream out
>> loud ...
> 
> Do you still have the old one? Would you try anyway?

ahem, I don't seem to have ef224ca2ce55e81acc6c3a74c3e8c00a00941c70, are
you sure that is the right hash?

> 
> johannes

cu
Dieter
