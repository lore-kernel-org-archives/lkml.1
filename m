Return-Path: <linux-kernel-owner+w=401wt.eu-S1752356AbXLDHRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356AbXLDHRm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 02:17:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751698AbXLDHRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 02:17:34 -0500
Received: from an-out-0708.google.com ([209.85.132.244]:23142 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbXLDHRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 02:17:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HMWqtN4jpbkobD4eGweN+GSdYHGBNVj+4R9A1Rr756YCIlL1rDlu9pBX1M/1VzRnDJBkSWhyDtSiemnGmBK68rkrfmVgXpiKOTDFLmmSGRFe5QUXWZxu95L+jYlTfg0tfkW2H3vgEa/1a+FVgmDhSPKSqybvcY8xeWgRqa8ryfU=
Message-ID: <a8e1da0712032317k492ad15aq917668d8a9413c61@mail.gmail.com>
Date: Tue, 4 Dec 2007 15:17:32 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: Re: The use of KOBJ_NAME_LEN
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.0.9999.0712040150010.31686@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071204064547.GA17094@darkstar.lan>
	 <alpine.LFD.0.9999.0712040150010.31686@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 4, 2007 2:50 PM, Robert P. J. Day <rpjday@crashcourse.ca> wrote:
>
> On Tue, 4 Dec 2007, Dave Young wrote:
>
> > Hi,
> > Does the KOBJ_NAME_LEN really means the limit of kobject name length? seems not . And if it's true, is the KOBJ_NAME_LEN of 20 enough to use?
> >
> > In the kobject_set_name, the limit is 1024. Looks like either the comment or the code should be updated.
> >
> > /**
> >  *      kobject_set_name - Set the name of an object
> >  *      @kobj:  object.
> >  *      @fmt:   format string used to build the name
> >  *
> >  *      If strlen(name) >= KOBJ_NAME_LEN, then use a dynamically allocated
> >  *      string that @kobj->k_name points to. Otherwise, use the static
> >  *      @kobj->name array.
> >  */
>
> the comment seems fairly clear -- if the name is sufficiently short,
> it's stored in the static array.  if not, then it's stored in
> dynamically allocated space.

Yes, It's clear, but it is not the topic I talk about.
Please look at the KOBJ_NAME_LEN macro usage.

>
> rday
> ========================================================================
> Robert P. J. Day
> Linux Consulting, Training and Annoying Kernel Pedantry
> Waterloo, Ontario, CANADA
>
> http://crashcourse.ca
> ========================================================================
>
