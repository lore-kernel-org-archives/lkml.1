Return-Path: <linux-kernel-owner+w=401wt.eu-S1756097AbXH3DKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097AbXH3DKG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 23:10:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753073AbXH3DJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 23:09:56 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:23757 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbXH3DJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 23:09:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:references:in-reply-to:subject:date:message-id:mime-version:content-type:content-transfer-encoding:x-mailer:thread-index:content-language;
        b=Vw4V3RjREnI4Ob2nKUohzA4mKH6P0GIwymf4lawI5FyrPwGZgUzQRPgz/ZoOHuglYOTGv3jPAUmO1SZU475cRFGCvK7xsLvpn6FcREYHfsJQiDGgvCilClfcjh3IT9bTzGK+G7MQW9w6JkXJSl1XSqW8Mrv0gONzYlrlHDn6heE=
From: "Hua Zhong" <hzhong@gmail.com>
To: "'Ian Kent'" <raven@themaw.net>
Cc: "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       <autofs@linux.kernel.org>, "'Adrian Bunk'" <bunk@kernel.org>
References: <00f401c7ea7f$6db9fc80$492df580$@com>	 <20070829224754.GW26410@stusta.de> <1188442804.4090.10.camel@raven.themaw.net>
In-Reply-To: <1188442804.4090.10.camel@raven.themaw.net>
Subject: RE: regression of autofs for current git?
Date: Wed, 29 Aug 2007 20:09:36 -0700
Message-ID: <010401c7eab3$38d16100$aa742300$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcfqseJK+5ALv7R3StOP78+N7nT+NAAAM4cA
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am in the process of bisecting now. It takes a while but the bad commit is
between 2.6.22 and 13f9966b3ba5b45f47f2ea0eb0a90afceedfbb1f (June 28). I'll
continue tomorrow.

My system is FC4. 

autofs-4.1.4-26
nfs-utils-1.0.7-13.FC4

By the way, the particular autofs commit Andrian sent is innocent. It's
something else.

It will still take me about 10 reboots to bisect. If anyone has a patch for
me to try, I'll give it a shot tomorrow.

> -----Original Message-----
> From: Ian Kent [mailto:raven@themaw.net]
> Sent: Wednesday, August 29, 2007 8:00 PM
> To: Hua Zhong
> Cc: 'Linux Kernel Mailing List'; autofs@linux.kernel.org; Adrian Bunk
> Subject: Re: regression of autofs for current git?
> 
> On Thu, 2007-08-30 at 00:47 +0200, Adrian Bunk wrote:
> > On Wed, Aug 29, 2007 at 01:58:58PM -0700, Hua Zhong wrote:
> >
> > > Hi,
> >
> > Hi Hua,
> >
> > > I am wondering if this is a known issue, but I just built the
> current git
> > > and several autofs mounts mysteriously disappeared. Restarting
> autofs could
> > > fix some, but then lose others. 2.6.22 was fine.
> > >
> > > Is there anything I could check other than bisect? (It may take
> some time
> > > for me to get to it)
> >
> > the commit below is the only autofs4 patch that went into the git
> tree
> > since 2.6.22.
> >
> > Does reverting it fix your problems?
> 
> Maybe but there is an NFS change that appears to be in the current
> 2.6.23-rc kernel and doesn't seem to be in 2.6.22 that is known to
> break
> some autofs maps and also breaks amd.
> 
> I can't seem to locate the commit just now.
> In the meantime what version of user space autofs and nfs-utils are you
> running?
> And can you post your autofs maps please?
> 
> Ian
> 
> 


