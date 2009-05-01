Return-Path: <linux-kernel-owner+w=401wt.eu-S1765349AbZEAU2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765349AbZEAU2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 16:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755281AbZEAU2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 16:28:04 -0400
Received: from mail-qy0-f196.google.com ([209.85.221.196]:53887 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761186AbZEAU2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 16:28:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=p+bUmX/9Q1TzgxDurCg2XRNhi+vdVZh8DequTHjVdmhnPac7oTa+5sY0Wb689dq7vD
         s3JWeqZiynfWEdq6CiA5fWMn+BmzsZK+qKNd7iNNuRTkkoB81uhg1dSs3YphhsjmXzQl
         99GQpIB9tSAHwiKCM948deSSwJrf5kqjfcrfY=
MIME-Version: 1.0
In-Reply-To: <1241165805.13562.2.camel@johannes.local>
References: <f7848160904301838q4883106fq8d31e2e7c0b10a14@mail.gmail.com>
	 <1241165805.13562.2.camel@johannes.local>
Date: Fri, 1 May 2009 16:28:01 -0400
Message-ID: <f7848160905011328o68010ba0rf8e18fa7ce88c7b5@mail.gmail.com>
Subject: Re: Probe Timeouts with 47afbaf5af9454a7a1a64591e20cbfcc27ca67a8
From: Parag Warudkar <parag.lkml@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, niel.lambrechts@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/1/09, Johannes Berg <johannes@sipsolutions.net> wrote:
>How did you check that it isn't reverted in compat-wireless anyway?
>[..] if you had made an attempt to verify that the code in
> there works, you would have found that indeed there's no reason to
> revert this commit since the fix for it went in, and is literally a
> single line.

Johannes,

Just got around to downloading today's compat-wireless and it doesn't
work for me - frequent disconnects this time with response timeouts -

 9731.902114] wlan1: RX ReassocResp from 00:1e:e5:6a:2c:c2
(capab=0x411 status=0 aid=1)
[ 9731.902117] wlan1: associated
[ 9886.744022] wlan1: no probe response from AP 00:1e:e5:6a:2c:c2 -
disassociating
[ 9887.594299] wlan1: authenticate with AP 00:1e:e5:6a:2c:c2
[ 9887.596953] wlan1: authenticated
[ 9887.596958] wlan1: associate with AP 00:1e:e5:6a:2c:c2
[ 9887.600997] wlan1: RX ReassocResp from 00:1e:e5:6a:2c:c2
(capab=0x411 status=0 aid=1)
[ 9887.601000] wlan1: associated
[ 9930.640019] wlan1: no probe response from AP 00:1e:e5:6a:2c:c2 -
disassociating

Of course mainline continues to work fine after reverting
47afbaf5af9454a7a1a64591e20cbfcc27ca67a8.


No offense, but that to me is yet another reason to either revert or
get a proper fix in mainline whichever is sooner. (Sorry but
non-working network is impossible to live with - especially so when I
have to rely on mainline to get a working network (compat-wireless
doesn't work and the distro kernel just freezes when connecting to the
network and there is no fix in sight yet [*] ) )

Thanks
Parag

[*] https://bugs.launchpad.net/bugs/364333
