Return-Path: <linux-kernel-owner+w=401wt.eu-S1754664AbYEGNUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbYEGNUK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 09:20:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750898AbYEGNTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 09:19:54 -0400
Received: from wr-out-0506.google.com ([64.233.184.227]:23177 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbYEGNTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 09:19:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=PVuLpK0v6jIwj0ZQupEBqqLpGxgYeuxNxY/IeIidE4YXqTwHOAPE6oftjLerI4fz0CC2AgibssgelNzYQhl2RgvaKdbyyAncAlRTT1NCxkMxs1AT0oSeqRKVush4oIXHiaOnB665nPil+Ut1vVRDbkyi+2vlhnZWP/MWY+Je6NU=
Message-ID: <2f11576a0805070619x11c462fdpbee1b652a83d7071@mail.gmail.com>
Date: Wed, 7 May 2008 22:19:51 +0900
From: "KOSAKI Motohiro" <m-kosaki@ceres.dti.ne.jp>
To: Nadia.Derbey@bull.net
Subject: Re: [PATCH 0/9] Scalability requirements for sysv ipc - v3
Cc: manfred@colorfullife.com, paulmck@linux.vnet.ibm.com,
       lnxninja@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       efault@gmx.de, akpm@linux-foundation.org
In-Reply-To: <20080507113553.395937000@bull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080507113553.395937000@bull.net>
X-Google-Sender-Auth: 4af56b5ba5b531f1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

nice improvement.
but...

>    2.6.25-rc3-mm1   2.6.25-rc3-mm1+   2.6.25-mm1   Patched 2.6.25-mm1
>  1         1168441           1064021       876000               947488
>  2         1094264            921059      1549592              1730685
>  3         2082520           1738165      1694370              2324880
>  4         2079929           1695521       404553              2400408
>  5         2898758            406566       391283              3246580
>  6         2921417            261275       263249              3752148
>  7         3308761            126056       191742              4243142
>  8         3329456            100129       141722              4275780
>
>  1st column: stock 2.6.25-rc3-mm1
>  2nd column: 2.6.25-rc3-mm1 + ipc patches (store ipcs into idrs)
>  3nd column: stock 2.6.25-mm1
>  4th column: 2.6.25-mm1 + this pacth series.

this result is slightly odd.

similar to 2.6.25-rc3-mm1 and patched-2.6.25-mm1
similar to 2.6.25-mm1 and 2.6.25-rc3-mm1

but

not similar to 2.6.25-rc3-mm1 and patched-2.6.25-rc3-mm1
not similar to 2.6.25-mm1 and patched-2.6.25-mm1

Is patched-2.6.25-rc3-mm1 and patched-2.6.25-mm1 applied the same patch?
or I misunderstand how to see your chart?
