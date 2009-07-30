Return-Path: <linux-kernel-owner+w=401wt.eu-S1751616AbZG3ShT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616AbZG3ShT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 14:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751113AbZG3ShT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 14:37:19 -0400
Received: from smtp.microsoft.com ([131.107.115.214]:28177 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbZG3ShS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 14:37:18 -0400
From: Hank Janssen <hjanssen@microsoft.com>
To: Nicolas Palix <npalix@diku.dk>, Greg KH <gregkh@suse.de>
CC: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] Staging: hv: Replace typedef SG_BUFFER_LIST by struct
 scatterlist
Thread-Topic: [PATCH] Staging: hv: Replace typedef SG_BUFFER_LIST by struct
 scatterlist
Thread-Index: AQHKESz+R90nUjqrxU+OXKKS+83j4ZCOsDkAgAArswD//4sG0A==
Date: Thu, 30 Jul 2009 18:37:16 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C56209A94E87@TK5EX14MBXC114.redmond.corp.microsoft.com>
References: <200907301737.23849.npalix@diku.dk>
 <20090730155844.GB20557@suse.de>
 <Pine.LNX.4.64.0907302020250.13698@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0907302020250.13698@ask.diku.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Nicolas,

I was getting into the RingBuffer as well. Do you want to combine efforts?

Thanks,

Hank.


On Thu, 30 Jul 2009, Greg KH wrote:

> On Thu, Jul 30, 2009 at 05:37:23PM +0200, Nicolas Palix wrote:
>>
>> typedef SG_BUFFER_LIST is removed and its uses are replaced by the use of
>> struct scatterlist.
>
> Sweet!  thanks for doing this, very nice job, I'll go queue it up.

I tried to change the RingBuffer too but I did not know
which API I should use.
The ring buffer in kernel/trace seems fine but it has some
dedicated features.

Any hint?
Of which infrastructure are you thinking in your previous mail?


