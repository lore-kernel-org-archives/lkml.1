Return-Path: <linux-kernel-owner+w=401wt.eu-S1946556AbXD3SWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946556AbXD3SWF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 14:22:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423421AbXD3SWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 14:22:04 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:20493 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423401AbXD3SWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 14:22:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iSvj1NczJEoGG7yoH4jGEjCc6azFiHPgUFtjxLXjiO0FmehBz3joEzK/Lo0dQJ1KrDNnCzhXoCPARK1o5kd2Vy0kRwg0km5PSFq4mPhzqORtYxBvLX7LyzkOK2oqDLTJYBoFWzUm0z+xxKQrarf2C1NWjXun9mfOtAQk6wQpYO0=
Message-ID: <f158dc670704301122r79a7be9aic65bd755c677203@mail.gmail.com>
Date: Mon, 30 Apr 2007 12:22:00 -0600
From: "Latchesar Ionkov" <lionkov@gmail.com>
To: "Jan Engelhardt" <jengelh@linux01.gwdg.de>
Subject: Re: [PATCH] 9p: create separate 9p client interface
Cc: "Andrew Morton" <akpm@osdl.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "V9FS Developers" <v9fs-developer@lists.sourceforge.net>
In-Reply-To: <Pine.LNX.4.61.0704302015300.29151@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f158dc670704300832l36889bf2kfa4480addbe8cfb2@mail.gmail.com>
	 <Pine.LNX.4.61.0704302015300.29151@yvahk01.tjqt.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/30/07, Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
>
> On Apr 30 2007 09:32, Latchesar Ionkov wrote:
> Hi!
>
> > --- a/fs/9p/Makefile
> > +++ b/fs/9p/Makefile
> > @@ -3,8 +3,8 @@ obj-$(CONFIG_9P_FS) := 9p.o
> > 9p-objs := \
> > trans_fd.o \
> > mux.o \
> > -     fcall.o \
> >       conv.o \
> > +     clnt.o \
>
> Do you pay by the letter, or why is not the source file called client.c? :)

The harder to understand, the better ;) I'll change it to client.c
when I resubmit with part of the code in net/9p.

Thanks,
    Lucho
