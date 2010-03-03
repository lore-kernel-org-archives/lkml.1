Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908Ab0CCWNf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 17:13:35 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:59858
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756854Ab0CCWN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 17:13:29 -0500
X-SpamScore: -29
X-BigFish: VPS-29(zz1432R98dN936eM9371Pzz1202hzzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <4B8EDC86.20806@am.sony.com>
Date: Wed, 3 Mar 2010 14:02:46 -0800
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: "Levand, Geoffrey" <Geoffrey.Levand@am.sony.com>
CC: Andy Shevchenko <andy.shevchenko@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: Re: [PATCHv2] drivers: net: optimize hex2bin()
References: <4B8C485A.8000409@am.sony.com> <1267516766-25977-1-git-send-email-andy.shevchenko@gmail.com> <4B8D370A.4030609@am.sony.com>
In-Reply-To: <4B8D370A.4030609@am.sony.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Mar 2010 22:02:46.0513 (UTC) FILETIME=[41C18E10:01CABB1D]
X-SEL-encryption-scan: scanned
X-Reverse-DNS: mail8.fw-sd.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 03/02/2010 08:04 AM, Levand, Geoffrey wrote:
> On 03/01/2010 11:59 PM, Andy Shevchenko wrote:
>> Optimize hex2bin() function used in ps3_gelic_wireless.c. It requires to have
>> hex_to_bin() implementation introduced by starter patch [1] in series.
>> 
>> [1] http://patchwork.kernel.org/patch/81224/
>> 
>> Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
>> Cc: Geoff Levand <geoffrey.levand@am.sony.com>
>> ---
>>  drivers/net/ps3_gelic_wireless.c |   13 +++++--------
>>  1 files changed, 5 insertions(+), 8 deletions(-)
> 
> Looks good, thanks.
> 
> Acked-by: Geoff Levand <geoffrey.levand@am.sony.com>

Sorry, this is now a NAK.

Some PS3 driver clean-ups were merged, and Andy's change
is no longer needed.  Here is the commit:

 c1596b75c29eb5b32c65ef1e186c8b08c289bf05 - ps3_gelic_wireless: Remove PS3 gelic legacy wpa support

Sorry for asking for an updated patch when this
other change was queued.

-Geoff 

