Return-Path: <linux-kernel-owner+w=401wt.eu-S1753627AbZITBnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627AbZITBnb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 21:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753458AbZITBna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 21:43:30 -0400
Received: from mail-yw0-f175.google.com ([209.85.211.175]:39583 "EHLO
	mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972AbZITBna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 21:43:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=xpyj5uN/GQ3rWNRM8NhUVBeZdlR1xBapX5bv2v3cYgJwXqNd2VtfRpWvjBrKUyzIOE
         X/aqwn+2qANstn/2hsyuTlEKllMOh3+UTKaq5pdWSkGmT67gAoyTGLDCygPpTNRTqkzy
         NfZpIEsmCpYCP3Q3nMvZCEYLmBJDN38D+C+FE=
MIME-Version: 1.0
In-Reply-To: <20090918195005.GA11726@elte.hu>
References: <ac3eb2510909171218k4963fc7dv8fb7549007e511aa@mail.gmail.com>
	 <ac3eb2510909171526ga51ecfag74af1a34a0437189@mail.gmail.com>
	 <alpine.LFD.2.01.0909171709410.4950@localhost.localdomain>
	 <1253238637.4071.10.camel@yio.site> <20090918060210.GC7104@kroah.com>
	 <alpine.LFD.2.01.0909180717380.4950@localhost.localdomain>
	 <20090918150541.GB9307@kroah.com>
	 <ac3eb2510909180837p195704e4y907e6f564acf6efd@mail.gmail.com>
	 <ac3eb2510909181235m33846928sa8c790758c66233@mail.gmail.com>
	 <20090918195005.GA11726@elte.hu>
Date: Sun, 20 Sep 2009 11:43:33 +1000
Message-ID: <21d7e9970909191843l6fbb835bme509c18cedfd728c@mail.gmail.com>
Subject: Re: [bug] /etc/profile: line 30: /dev/null: Permission denied (Was: 
	Re: [PATCH] Remove broken by design and by implementation devtmpfs 
	maintenance disaster)
From: Dave Airlie <airlied@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Self-contained /dev is great, udev is a total PITA on older distros (on
> this box it sometimes takes 3 minutes for udev to boot ...) so turning
> on devtmpfs and getting something functional in exchange is a big
> selling point IMO.

udev taking 3 minutes usually means you have a kernel driver bug,
udev doesn't have a sleep for 3 minutes, it loads drivers and usually
waits for them to finish. Since someone decided to merge a stupid
floppy PNP match I've seen a lot of floppyless machines hit a 30sec
udev delay. so many that we disabled the pnp floppy on Fedora.

Dave.
