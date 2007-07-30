Return-Path: <linux-kernel-owner+w=401wt.eu-S933317AbXG3OFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933317AbXG3OFV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 10:05:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761226AbXG3OFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 10:05:01 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:45180 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759941AbXG3OFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 10:05:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=o3g1BsYaaiElE4Mbnx+hZ44YWylwgc2KTJRyKesfLtSBxnXwq9CdaYfwmQo8kj+cE9nyM4qEUykaRkzVqbvCJxLdLHwtRUpKotewcelizCFR37iT0eEVkeFw0OdMrVcyzZw/82aETCYPtuVK/CSP+Rksq4jA9so+B3UA/syGvX8=
Message-ID: <9a8748490707300704r238e2a1fn7dcc1f597ed7d5db@mail.gmail.com>
Date: Mon, 30 Jul 2007 16:04:58 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH][hid] Fix a NULL pointer dereference when we fail to allocate memory
Cc: "Jiri Kosina" <jkosina@suse.cz>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Michael Haboustak" <mike-@cinci.rr.com>, "Andreas Gal" <gal@uci.edu>,
       "Vojtech Pavlik" <vojtech@suse.cz>,
       "Greg Kroah-Hartman" <greg@kroah.com>,
       linux-input@atrey.karlin.mff.cuni.cz
In-Reply-To: <46A2EF75.70700@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707220006.20359.jesper.juhl@gmail.com>
	 <46A2EF75.70700@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/07/07, Jiri Slaby <jirislaby@gmail.com> wrote:
> Jesper Juhl napsal(a):
> >  drivers/hid/usbhid/hid-core.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
> > index b2baeae..3ff7468 100644
> > --- a/drivers/hid/usbhid/hid-core.c
> > +++ b/drivers/hid/usbhid/hid-core.c
> > @@ -743,7 +743,7 @@ static struct hid_device *usb_hid_configure(struct usb_interface *intf)
> >       hid->quirks = quirks;
> >
> >       if (!(usbhid = kzalloc(sizeof(struct usbhid_device), GFP_KERNEL)))
>
> Out of curiosity, where is this freed?
>
Sorry, I didn't notice your email until now.  It's not freed anywhere
:-(   But I see that Jiri Kosina just queued a fix for that, so now
all is good :-)

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
