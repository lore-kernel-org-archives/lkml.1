Return-Path: <linux-kernel-owner+w=401wt.eu-S1753565AbZFHDd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbZFHDd0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 23:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbZFHDdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 23:33:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:8839 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbZFHDdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 23:33:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,322,1241420400"; 
   d="scan'208";a="522520615"
From: "Gao, Yunpeng" <yunpeng.gao@intel.com>
To: Greg KH <gregkh@suse.de>, Jiri Slaby <jirislaby@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "devel@linuxdriverproject.org" <devel@driverdev.osuosl.org>
Date: Mon, 8 Jun 2009 11:34:04 +0800
Subject: RE: [PATCH 1/2]Intel Moorestown NAND driver patch for mainline
Thread-Topic: [PATCH 1/2]Intel Moorestown NAND driver patch for mainline
Thread-Index: AcnmuMsd6qFdaHI5SWah+HCb2Cc2fwBLcIlg
Message-ID: <38D9F46DFF92C54980D2F2C1E8EE313001A45F4EF0@pdsmsx503.ccr.corp.intel.com>
References: <20090606164455.GB27257@intel.com> <4A2A4EF7.7070509@gmail.com>
 <20090606145756.GA29732@suse.de>
In-Reply-To: <20090606145756.GA29732@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n583YB54001676



>-----Original Message-----
>From: Greg KH [mailto:gregkh@suse.de]
>Sent: 2009Äê6ÔÂ6ÈÕ 22:58
>To: Jiri Slaby
>Cc: Gao, Yunpeng; linux-kernel@vger.kernel.org; devel@linuxdriverproject.org
>Subject: Re: [PATCH 1/2]Intel Moorestown NAND driver patch for mainline
>
>On Sat, Jun 06, 2009 at 01:11:51PM +0200, Jiri Slaby wrote:
>> On 06/06/2009 06:44 PM, Yunpeng Gao wrote:
>> > diff --git a/drivers/staging/mrst_nand/ffsport.c
>b/drivers/staging/mrst_nand/ffsport.c
>> > new file mode 100644
>> > index 0000000..5a919f4
>> > --- /dev/null
>> > +++ b/drivers/staging/mrst_nand/ffsport.c
>> > @@ -0,0 +1,953 @@
>> > +void glob_udelay(unsigned long usecs)
>> > +{
>> > +	udelay(usecs);
>> > +}
>> > +
>> > +void glob_mdelay(unsigned long msecs)
>> > +{
>> > +	mdelay(msecs);
>> > +}
>>
>> Unneeded wrappers.
>
><snip>
>
>Thanks for the review, this is one reason why it's in the staging
>directory :)
>
>Hopefully someone can send follow-on patches implementing these fixups
>(hint...)
>
>greg k-h

Hi Greg,

Thanks a lot for all the comments and reviewing works of community. This NAND driver is still under development. Some functional features are not implemented yet. Also, I know that there's a lot of thing I can do to improve the quality of the driver code.

I plan to enable the new functional features, adjust the data structure, lower the memory footprint in later one or two months. And will submit follow-on patches after I finished those works. I'll try to address the comments of Jiri Slaby in those patches.

Thanks.

Rgds,
Yunpeng
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
