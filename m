Return-Path: <linux-kernel-owner+w=401wt.eu-S1767275AbXDTVki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767275AbXDTVki (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 17:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754512AbXDTVki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 17:40:38 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:46551 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767275AbXDTVkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 17:40:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=p35T3G3Ez4y0mC+w4U9XLlZVH1qpzT5kD0PMs5MZNyhvmtTQKTc4xf7XMbc5DtI4vHiazUkBaN9Uj1UTIv6ZWwmjmF7nRYVcXs+VT5txiyX1FfjR9790eRZVGV5bWC7ENdu+T1VE9ULSRl/5TV7nBaUEOP7smFP/hAZudQQmJKc=
Message-ID: <cb7bb73a0704201440i55557a13v5ad5a71617dc1239@mail.gmail.com>
Date: Fri, 20 Apr 2007 23:40:18 +0200
From: "Giuseppe Bilotta" <giuseppe.bilotta@gmail.com>
To: "Vojtech Pavlik" <vojtech@suse.cz>
Subject: Re: Acecad USB Tablet: usbmouse takeover and odd motion
Cc: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       "Jiri Kosina" <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
       edouard.tisserant@wanadoo.fr
In-Reply-To: <20070420204724.GB5334@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cb7bb73a0704191940s1fd6487j9a4412aebd4342c0@mail.gmail.com>
	 <Pine.LNX.4.64.0704200903370.29846@jikos.suse.cz>
	 <cb7bb73a0704200126x1e7893fem5902fe79eefb70b7@mail.gmail.com>
	 <Pine.LNX.4.64.0704201533300.5138@jikos.suse.cz>
	 <cb7bb73a0704200855xe841ecdoc9a0f67fc6f7009e@mail.gmail.com>
	 <d120d5000704200901m44c9a3aei9ee0572c3b0a61ab@mail.gmail.com>
	 <cb7bb73a0704200909h2f47e04cq87cb3dd91d7144f7@mail.gmail.com>
	 <20070420204724.GB5334@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/20/07, Vojtech Pavlik <vojtech@suse.cz> wrote:
> On Fri, Apr 20, 2007 at 06:09:55PM +0200, Giuseppe Bilotta wrote:
> > On 4/20/07, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > >On 4/20/07, Giuseppe Bilotta <giuseppe.bilotta@gmail.com> wrote:
> > >>
> > >> Sorry, it seems I was wrong, it's not usbhid but usbmouse taking over.
> > >> After a fresh plug (e.g. at bootup) I get the following:
> > >>
> > >
> > >Well, the question is - why do you have usbmouse module on your system?
> >
> > Stock Debian kernel 2.6.18 comes with it.
> >
> > With my custom kernels I can probably skip compiling it at all, if you
> > so suggest; should I blacklist it for the distro kernel? Or is there a
> > chance that some random USB mouse plugged in would fail to function by
> > doing so?
>
> usbmouse and usbkbd are only intended for embedded systems where the
> full usbhid doesn't fit and for testing purposes: Normal distros
> shouldn't have them enabled.

Oh, I see. I'll blacklist those modules, maybe also issue a ticket on
the Debian BTS.

Thanks all.

-- 
Giuseppe "Oblomov" Bilotta
