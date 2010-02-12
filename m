Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab0BLXLh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 18:11:37 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:46044
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751568Ab0BLXLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 18:11:35 -0500
X-SpamScore: -30
X-BigFish: VPS-30(zz1432R98dN936eM9371Pa022Izz1202hzzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <4B75E023.8060501@am.sony.com>
Date: Fri, 12 Feb 2010 15:11:31 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Bernhard Schiffner <bernhard@schiffner-limbach.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [mmiotrace] Make timestamps as printk() does.
References: <201002072205.26665.bernhard@schiffner-limbach.de> <4B75D752.1010904@lwfinger.net>
In-Reply-To: <4B75D752.1010904@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-SEL-encryption-scan: scanned
X-Reverse-DNS: mail8.fw-sd.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2010 02:33 PM, Larry Finger wrote:
> On 02/07/2010 03:05 PM, Bernhard Schiffner wrote:
>> Hallo,
>>
>> this little patch makes a simple "sort -m" on output gotten from dmesg and  
>> mmiotrace possible.
>> It's a real help at least for me.
>>
>> Bernhard
>> (CC me please, I'am not on this list.)
> 
> NACK. This sort of transformation is best left to local tools.

The tools can be much easier to maintain and use,
if there's consistency in the output format from
the kernel.  There are already tools which read and
process the printk timestamp format (with time in
[sec.usec] format at the beginning of the line).
One is scripts/show-delta.

 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

