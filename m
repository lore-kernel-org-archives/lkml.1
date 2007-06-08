Return-Path: <linux-kernel-owner+w=401wt.eu-S1030692AbXFHOa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030692AbXFHOa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 10:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969163AbXFHOaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 10:30:18 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:19810 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968873AbXFHOaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 10:30:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=pAGEocK5oKrbiF+iIZilxX1anBG3n8KrPGryLVK+uJAkJR1D0nJs6kn0L6z0Dm91sO8eCoh21b7vQdZAeVQ106gKM/+ZtXreiLIWQ8h/PxG11qelqsz830olCjaxLSCONaKGIFc1iE7SqgtaNw5w1Eo26mou8Xh+A04tslXc/Ww=
Subject: Re: Add INPUT support to toshiba_acpi
From: Richard Hughes <hughsient@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Bastien Nocera <hadess@hadess.net>,
       John Belmonte <john@neggie.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>
In-Reply-To: <d120d5000706080723i74adf0e2p8906469b72b948e@mail.gmail.com>
References: <1180614979.2693.26.camel@localhost.localdomain>
	 <1180788652.2355.27.camel@localhost.localdomain>
	 <20070602142333.GA3452@srcf.ucam.org>
	 <200706030048.40393.dtor@insightbb.com> <1181235539.2610.72.camel@work>
	 <d120d5000706080723i74adf0e2p8906469b72b948e@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 08 Jun 2007 15:30:16 +0100
Message-Id: <1181313016.2499.51.camel@work>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-08 at 10:23 -0400, Dmitry Torokhov wrote:
> On 6/7/07, Richard Hughes <hughsient@gmail.com> wrote:
> > On Sun, 2007-06-03 at 00:48 -0400, Dmitry Torokhov wrote:
> > >
> > >
> > > It looks like KEY_COFFE comes from 0x0c/0x19e - AL Terminal
> > > Lock/Screensaver
> > > so your interpretation is indeed correct. I guess I better add an
> > > alias to
> > > input.h
> >
> > What's the status of this patch? Good for merging?
> 
> Not my call - John is the official maintainer of the driver. However
> from input layer POV it looks good.

Good, thanks.

> > Do you want me to
> > redo the current patch using input-polldev
> 
> The patch I send to you earlier already does this. I am attaching a
> refreshed version that used KEY_COFFEE instead of KEY_BREAK.

Brilliant, these look great.

> > and the new setkeycode stuff?
> 
> And I have the patch doing this as well (attached). If you could
> please give it a try I'd appreciate it.

You beat me to it {hastily removes item from TODO...} :-)

I'll give it a try as soon as possible, thanks.

Richard.


