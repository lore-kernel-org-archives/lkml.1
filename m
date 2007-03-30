Return-Path: <linux-kernel-owner+w=401wt.eu-S1753931AbXC3Qqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbXC3Qqn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 12:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753941AbXC3Qqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 12:46:43 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:4485 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbXC3Qqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 12:46:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JHxW0a2LIUCJC0nFU6FLElBk2U2TBswWNqSHpQ7XETTDr2m0GG9p3fHNlf8gaJAgMBOfWHhqlOiITNt/GX+74tB3JnoG8gop390u9GO9EbR9GiMhHhdhGP/eiCwE33MfLerCseMtrZxwf9MtIEOjL24px870RGk0kCOvp8rPAms=
Message-ID: <d120d5000703300946k4268dfa0kadd3bf3094accd09@mail.gmail.com>
Date: Fri, 30 Mar 2007 12:46:41 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: FF layer restrictions [Was: [PATCH 1/1] Input: add sensable phantom driver]
Cc: "johann deneux" <johann.deneux@gmail.com>,
       "=?ISO-8859-1?Q?\"STenyaK_(Bruno_Gonz=E1lez)\"?=" <stenyak@gmail.com>,
       "Anssi Hannula" <anssi.hannula@gmail.com>,
       "Linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       linux-input@atrey.karlin.mff.cuni.cz
In-Reply-To: <460AEA8C.2050102@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2460126662758025813@fi.muni.cz> <460983D6.7070409@gmail.com>
	 <38b3b7c0703271434u2fddc4d1jc2b9af097e9c95b2@mail.gmail.com>
	 <200703272308.34441.dtor@insightbb.com> <460AE933.6010209@gmail.com>
	 <460AEA8C.2050102@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/28/07, Jiri Slaby <jirislaby@gmail.com> wrote:
> Jiri Slaby napsal(a):
> > Dmitry Torokhov napsal(a):
> >> On Tuesday 27 March 2007 17:34, johann deneux wrote:
> >>> What about adding a member to ff_effect which would be the number of the motor?
> >>> We can't change the layout of ff_effect too much though, so we have to
> >>> find unused bits and put them to work.
> >>>
> >>> For instance, we could replace
> >>>
> >>> __u16 type;
> >>>
> >>> by
> >>>
> >>> __u8 motor;
> >>> __u8 type;
> >>>
> >> Splitting type field seems to be a good idea.
> >
> > Maybe stupid question, but what about endianness + backward compatibility?
> > If we split it into motor,type sequence, it would break LE (untouched BE),
> > if we do type,motor, it is OK for LE (broken BE).
>
> Aha, and the question is: do
>
> #ifdef __BIG_ENDIAN
> #else
> #endif
>
> ?
>

I am so tempted to say "screw BE, there is not many users of FF layer"
but I am afraid we will have to do that #ifdef-fu.

-- 
Dmitry
