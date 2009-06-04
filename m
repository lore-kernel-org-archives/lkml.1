Return-Path: <linux-kernel-owner+w=401wt.eu-S1756326AbZFDCD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326AbZFDCD0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 22:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219AbZFDCDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 22:03:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:5870 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754217AbZFDCDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 22:03:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,301,1241420400"; 
   d="scan'208";a="463284126"
From: "Gao, Yunpeng" <yunpeng.gao@intel.com>
To: Greg KH <gregkh@suse.de>, Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Date: Thu, 4 Jun 2009 10:04:37 +0800
Subject: RE: linux-next: Tree for June 3 (staging)
Thread-Topic: linux-next: Tree for June 3 (staging)
Thread-Index: AcnkoUPMKNaTe+ayRmOjWVxSzG60nAAFoRKQ
Message-ID: <38D9F46DFF92C54980D2F2C1E8EE313001A457D1D2@pdsmsx503.ccr.corp.intel.com>
References: <20090603190952.2dd0cc70.sfr@canb.auug.org.au>
 <4A2695C1.2060104@oracle.com> <20090603152558.GA25725@suse.de>
 <4A269971.1050004@oracle.com> <20090603231152.GA18701@suse.de>
In-Reply-To: <20090603231152.GA18701@suse.de>
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
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n5423r54016909

Hi Greg,

Thanks for the reminder. I'll check the code in 2.6.30-rc8 and generate new patch to fix this bug as soon as. Thanks.

Rgds,
Yunpeng

>-----Original Message-----
>From: Greg KH [mailto:gregkh@suse.de]
>Sent: 2009Äê6ÔÂ4ÈÕ 7:12
>To: Randy Dunlap; Gao, Yunpeng
>Cc: Stephen Rothwell; linux-next@vger.kernel.org; LKML
>Subject: Re: linux-next: Tree for June 3 (staging)
>
>On Wed, Jun 03, 2009 at 08:40:33AM -0700, Randy Dunlap wrote:
>> Greg KH wrote:
>> > On Wed, Jun 03, 2009 at 08:24:49AM -0700, Randy Dunlap wrote:
>> >> Stephen Rothwell wrote:
>> >>> Hi all,
>> >>>
>> >>> Looks like a real rush since -rc7 ...
>> >>
>> >> drivers/staging/comedi/drivers/adq12b.c:328: error: implicit declaration
>of function 'udelay'
>> >>
>> >>
>> >> drivers/staging/mrst_nand/ffsport.c:360:error: 'struct request' has no
>member named 'sector'
>> >> drivers/staging/mrst_nand/ffsport.c:376:error: 'struct request' has no
>member named 'sector'
>> >> drivers/staging/mrst_nand/ffsport.c:376:error: 'struct request' has no
>member named 'current_nr_sectors'
>> >> drivers/staging/mrst_nand/ffsport.c:380:error: 'struct request' has no
>member named 'sector'
>> >> drivers/staging/mrst_nand/ffsport.c:381:error: 'struct request' has no
>member named 'current_nr_sectors'
>> >> drivers/staging/mrst_nand/ffsport.c:392:error: 'struct request' has no
>member named 'current_nr_sectors'
>> >> drivers/staging/mrst_nand/ffsport.c:499:error: implicit declaration of
>function 'elv_next_request'
>> >> drivers/staging/mrst_nand/ffsport.c:517:error: implicit declaration of
>function 'end_request'
>> >> drivers/staging/mrst_nand/ffsport.c:738:error: implicit declaration of
>function 'blk_queue_hardsect_size'
>> >
>> > Can I get your .config for this?  It works here with a "default" one.
>>
>> attached (for mrst_nand/ffsport.c build errors)
>
>Ah, thanks, figured it out.
>
>Gao, this looks like a problem in your ffsport.c code.  It isn't up to
>date with the 2.6.30-rc8 kernel tree.  Care to send me a follow-on patch
>to fix this up?
>
>thanks,
>
>greg k-h
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
