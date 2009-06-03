Return-Path: <linux-kernel-owner+w=401wt.eu-S1757450AbZFCNHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450AbZFCNHx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 09:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756363AbZFCNHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 09:07:32 -0400
Received: from smtp.nokia.com ([192.100.105.134]:48677 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756411AbZFCNHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 09:07:30 -0400
Message-ID: <4A267584.3030805@nokia.com>
Date: Wed, 03 Jun 2009 16:07:16 +0300
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "dpervushin@embeddedalley.com" <dpervushin@embeddedalley.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: ubi tree build failure
References: <20090603184408.49c7fb1f.sfr@canb.auug.org.au>	 <4A265DF6.3070602@nokia.com>  <4A2672A8.8020809@nokia.com> <1244034343.4074.2.camel@hp.diimka.lan>
In-Reply-To: <1244034343.4074.2.camel@hp.diimka.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 03 Jun 2009 13:07:20.0505 (UTC) FILETIME=[3A640290:01C9E44C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dmitry pervushin wrote:
> On Wed, 2009-06-03 at 15:55 +0300, Artem Bityutskiy wrote:
>> Did not see compile error on x86 as well. Anyway, I have added more
>> includes which seem to be missed. Hopefully this problem is fixed
>> now. Thanks!
> however it builds ok on arm too, adding #include <linux/err.h> should
> fix this..

Yeah, just did this. Added also linux/mutex.h which we also missed.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
