Return-Path: <linux-kernel-owner+w=401wt.eu-S1752501AbZAKHHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501AbZAKHHQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 02:07:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751097AbZAKHHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 02:07:01 -0500
Received: from rv-out-0506.google.com ([209.85.198.231]:12534 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbZAKHHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 02:07:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Dn2D6GjDttfKPnVD6HMuy0Z52xn87r80FO+pIggprWyMj1tkHhG2lmuF+m/uayQsVX
         4TK1HjLR9rzpLHN6IgNNnBG/cWy/WMlfpPWsRGVhKa5HMJX3oYjFqH7w32+hajRNdXul
         MsDV7AEthWak3jOWT+ezH+PE54zyS0MxVPl1I=
Message-ID: <86802c440901102307s2f58d106nce3400bc2dc01bd6@mail.gmail.com>
Date: Sat, 10 Jan 2009 23:07:00 -0800
From: "Yinghai Lu" <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [GIT PULL] bzip2/lzma kernel compression
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Alain Knaff" <alain@knaff.lu>,
       "Sam Ravnborg" <sam@ravnborg.org>
In-Reply-To: <49695E5B.3060308@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200901091845.n09IjBsT003630@terminus.zytor.com>
	 <86802c440901091252r2eab513dnf048851aea505d8d@mail.gmail.com>
	 <86802c440901091343p6797536bxf73107fa1672d29b@mail.gmail.com>
	 <20090111024756.GB7077@elte.hu> <49695E5B.3060308@zytor.com>
X-Google-Sender-Auth: d1f118d685d3c29a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2009 at 6:50 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Ingo Molnar wrote:
>>
>> was the linux/.lzma file corrupted, and once you removed the stale file it
>> all works fine and the problem does not come back?
>>
>> I.e. the tree as offered by hpa is fine?
>>
>
> That was the understanding I got.

yes.

something wrong with lzma util somehow. when loading is high, it could
produce corrupted result.
it seems only one window has problem.

it is opensuse 11.1 ...

YH
