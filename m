Return-Path: <linux-kernel-owner+w=401wt.eu-S1759703AbZC1VN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759703AbZC1VN2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 17:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759538AbZC1VNB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 17:13:01 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:39858 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759544AbZC1VNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 17:13:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:references:in-reply-to:subject:date:message-id
         :mime-version:content-type:content-transfer-encoding:x-mailer
         :thread-index:content-language;
        b=taseFKddxCpNXTsYczYghjRs7I6VFVV0fk4Q1sq9oedTr25NTM/wi0ZYxkyqpIjRWl
         /Ztt9UYsKgNxQaP4sSb5BiChvORUOybcMduiY0429jmn4JcBWHdUg1bgWnPn4Il8JlVJ
         hJgL79ZbgLGANrwUfmuShSdxnRqn2ceKSIneA=
From: "Hua Zhong" <hzhong@gmail.com>
To: "'Alex Goebel'" <alex.goebel@gmail.com>,
       "'Stefan Richter'" <stefanr@s5r6.in-berlin.de>
Cc: "'Jeff Garzik'" <jeff@garzik.org>, "'Mark Lord'" <lkml@rtr.ca>,
       "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Matthew Garrett'" <mjg59@srcf.ucam.org>,
       "'Alan Cox'" <alan@lxorguk.ukuu.org.uk>,
       "'Theodore Tso'" <tytso@mit.edu>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'David Rees'" <drees76@gmail.com>, "'Jesper Krogh'" <jesper@krogh.cc>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
References: <20090327051338.GP6239@mit.edu> <49CD4DDF.3000001@garzik.org>	 <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain>	 <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain>	 <49CD7B10.7010601@garzik.org> <49CD891A.7030103@rtr.ca>	 <49CD9047.4060500@garzik.org> <49CE2633.2000903@s5r6.in-berlin.de>	 <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de> <faa09fad0903280925t35a61c0aj2ae29d90337b9dab@mail.gmail.com>
In-Reply-To: <faa09fad0903280925t35a61c0aj2ae29d90337b9dab@mail.gmail.com>
Subject: RE: Linux 2.6.29
Date: Sat, 28 Mar 2009 14:12:44 -0700
Message-ID: <01fd01c9afe9$f0b60030$d2220090$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcmvwdAAw5SbIeISSmSubVcUvflAzQAJ+Qbw
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good point. We should throw away all the journaling junk and just go back 
to ext2. Why pay the extra cost for something we shouldn't optimize for? 
It's not like the kernel every crashes.

> Absolutely! That's what I thought all the time when following this
> (meanwhile quite grotesque) discussion. Even for ordinary
> home/office/laptop/desktop users (!=kernel developers), kernel crashes
> are simply not a realistic scenario any more to optimize anything for
> (which is due to the good work you guys are doing in making/keeping
> the kernel stable).
> 
> Alex


