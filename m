Return-Path: <linux-kernel-owner+w=401wt.eu-S1761011AbZLJQZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761011AbZLJQZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 11:25:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760999AbZLJQZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 11:25:24 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:41314 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757435AbZLJQZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 11:25:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=DC3bi1a09dGeE3jbD4RJbEONM606/Qe/q2x+KXd/vUOOj9zMaIYD4HksBDtup3JcNQ
         WyhHiihFB8AmUFqzSoZVJheI61myzqpqH0IZ/LwaVoIoUHY654EXmReBN+2cJj4vXxLp
         1l7MQiC5HWWdPIMUcIOJml/SJYCpn5Uc/q8wE=
Message-ID: <4B2120F2.3090301@tuffmail.co.uk>
Date: Thu, 10 Dec 2009 16:25:22 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: jim owens <jowens@hp.com>
CC: Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Dan Carpenter <error27@gmail.com>,
       Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH] Documentation/email-clients.txt: clarify Thunderbird
 section
References: <4B210C6C.3060103@tuffmail.co.uk> <4B2110E3.8010508@hp.com>
In-Reply-To: <4B2110E3.8010508@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jim owens wrote:
> I don't have a problem with your patch, but it is not true
> that you need to edit the prefs.js to disable line wrap.
>
> I did this in the gui to fix my own patch sending,
> under "Composition" you can set the wrap = 0.
>
> While changing format=flowed does require editing the file,
> on my version of Thunderbird, 2.0.0.23, it isn't clear how
> it breaks the patch to leave it flowed.
>
> And I have never used HTML, Preformat.
>
> jim
>
> Though now that I have said that, Andrew will probably
> tell me the patch I sent is broken ;)
>   

/google

The RFC for format=flowed says that it should escape lines which start 
with a space (by "space stuffing" - prepending an additional space).  So 
in theory it should completely break patches.   And indeed it does 
<http://gcc.gnu.org/ml/java-patches/2003-q2/msg00315.html>

Using HTML preformat in current versions of Thunderbird appears to send 
with a format=flowed content-type, and then violates the RFC by not 
performing any space-stuffing.

So if I look at format=flowed patch in my Sent email folder, I see that 
the message viewer correctly strips the first leading space in each 
line.  I.e. it breaks if you use copy+paste to get the patch out of 
Thunderbird (or any other format=flowed aware client).  File->Save As 
preserves the spaces though, allowing the patch to be applied.

Regards
Alan "Don't you feel better knowing that"
