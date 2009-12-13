Return-Path: <linux-kernel-owner+w=401wt.eu-S1753424AbZLMBMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbZLMBMH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 20:12:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752209AbZLMBL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 20:11:56 -0500
Received: from mail-px0-f189.google.com ([209.85.216.189]:60371 "HELO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750709AbZLMBLy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 20:11:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=g/AG0LsS7MwHMxPJhML9WeVHL7ytV2RI1x3wlgoUYWDoDQS9KU4jNfSbhKiDT1iZrA
         COJJlPiFdGBN/mEE/t2nM+tm9Q8qvT2GAr2E8xaZi2A3x0wv/2cjMXWy8O6IC7t0UHSn
         2uQG2akDbo4cMWiRHKatPwoWKhaYotCx+ooIU=
MIME-Version: 1.0
In-Reply-To: <20091211.214117.200029438.davem@davemloft.net>
References: <86802c440912112125v4aa72189ifcc2d16ecbf79cc4@mail.gmail.com>
	 <20091211.214117.200029438.davem@davemloft.net>
Date: Sat, 12 Dec 2009 17:05:27 -0800
X-Google-Sender-Auth: 6ca7613019cc45cf
Message-ID: <86802c440912121705y59eea3ebq3bdbd3e7459e748e@mail.gmail.com>
Subject: Re: nfs broken in net-next? -- now in mainline -- bisected: 
	d9f5950f90292f7cc42834338dfd5f44dc4cc4ca
From: Yinghai Lu <yinghai@kernel.org>
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, sri@us.ibm.com, herbert@gondor.apana.org.au,
       torvalds@linux-foundation.org, sjayaraman@suse.de,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 9:41 PM, David Miller <davem@davemloft.net> wrote:
> From: Yinghai Lu <yhlu.kernel@gmail.com>
> Date: Fri, 11 Dec 2009 21:25:49 -0800
>
>> [linux-2.6]# git bisect good
>> d9f5950f90292f7cc42834338dfd5f44dc4cc4ca is first bad commit
>> commit d9f5950f90292f7cc42834338dfd5f44dc4cc4ca
>> Author: Sridhar Samudrala <sri@us.ibm.com>
>> Date:   Wed Oct 7 12:24:25 2009 +0000
>>
>>     net: Make UFO on master device independent of attached devices
>
> Thanks.
>
> If I don't hear anything from Sridhar in a day or two I'll simply
> revert that change.

seems revert that doesn't fix the problem.

during bisecting, last several testing, i was using kexec instead of
boot from BIOS...

could be other commit like

[f86dcc5aa8c7908f2c287e7a211228df599e3e71] udp: dynamically
size hash tables at boot time

YH
