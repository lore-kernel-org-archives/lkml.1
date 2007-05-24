Return-Path: <linux-kernel-owner+w=401wt.eu-S1758719AbXEXXH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758719AbXEXXH3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 19:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752919AbXEXXHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 19:07:18 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:16498 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbXEXXHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 19:07:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ta6ua++McyZ/hAXXyKCm0/OZQ4YbS2j+7sLT5gycDpy6uBk9Sp7UlvWcNEoFDem1H5CbDJ1m7k8PD1GPk4QAPm4IP/xbKPJjOFLwxzlr8jrp+wLRVWyNRsqp8ugLYVvOrsse4T9eZOFd2cYFCzHpHJwBGJoRWAMhgqcSqJVc5OU=
Message-ID: <4af2d03a0705241607r3c9807c6h3841e87ea4736bd3@mail.gmail.com>
Date: Fri, 25 May 2007 01:07:09 +0200
From: "Jiri Slaby" <jirislaby@gmail.com>
To: "Markus Rechberger" <mrechberger@gmail.com>
Subject: Re: [PATCH 1/1] V4L: stk11xx, add a new webcam driver
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       video4linux-list@redhat.com
In-Reply-To: <d9def9db0705240724p59a48160l8a2338f4d44b0ef6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2172422218943432279@wsc.cz>
	 <d9def9db0705240724p59a48160l8a2338f4d44b0ef6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/24/07, Markus Rechberger <mrechberger@gmail.com> wrote:
> Hi Jiri,
>
> On 5/24/07, Jiri Slaby <jirislaby@gmail.com> wrote:
> > Well, no objections on v4l list, try to merge it. Any further comments will
> > be
> > appreciated.
> >
> > --
> >
> > stk11xx, add a new webcam driver
[...]
> > +static int stk1125_camera_asleep(struct stk11xx *dev)
> > +{
> > +     int value;
> > +
> > +     stk11xx_read_registry(dev, 0x0104, &value);
> > +     stk11xx_read_registry(dev, 0x0105, &value);
> > +     stk11xx_read_registry(dev, 0x0106, &value);
> > +
>
> why do you read these values (this is also something in the ongoing
> code I see, the read value just gets overwritten all the time)?

Well, as I tested, reads are neccesary, otherwise it doesn't work. And
when they are needed, you need to read the value to some place in
memory -- the &value.

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
