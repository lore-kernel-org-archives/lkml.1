Return-Path: <linux-kernel-owner+w=401wt.eu-S1758059AbZFOSXC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059AbZFOSXC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:23:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbZFOSWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:22:54 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:57986 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035AbZFOSWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:22:54 -0400
Message-ID: <4A36917D.5090305@msgid.tls.msk.ru>
Date: Mon, 15 Jun 2009 22:22:53 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Ken Witherow <ken@krwtech.com>
CC: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org
Subject: Re: PC speaker beeps in 2.6.30?
References: <4A365DA6.8000102@msgid.tls.msk.ru> <200906151857.36576.elendil@planet.nl> <Pine.LNX.4.64.0906151336010.28623@death.krwtech.com>
In-Reply-To: <Pine.LNX.4.64.0906151336010.28623@death.krwtech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ken Witherow wrote:
> On Mon, 15 Jun 2009, Frans Pop wrote:
> 
>> For me the system beep has been replaced by a beep in ALSA with .30.
>>
>> Do you have soundcard that uses HDA? Is CONFIG_SND_HDA_INPUT_BEEP set?
>> Does alsamixer show a "beep" control? Is that not muted and does it have
>> volume set?
> 
> I had this exact same problem. I ran make oldconfig and was never 
> prompted for the new HDA config options. I could be wrong, but I can't 
> remember make oldconfig behaving this way in the past (or maybe it 
> resulted in changes that didn't have any noticeable effect). Having to 
> reconfigure the kernel over not being prompted for a new config option 
> which changed established behavior was annoying to say the least.

As I noted in my other email, this option (CONFIG_SND_HDA_INPUT_BEEP)
is not new, it is present in 2.6.29 too.  So it's a behavor change which
is not "backed up" by a config option -- there's no option to prompt
for.

/mjt
