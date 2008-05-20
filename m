Return-Path: <linux-kernel-owner+w=401wt.eu-S932179AbYETRD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179AbYETRD5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 13:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759992AbYETRDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 13:03:38 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:38154 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758627AbYETRDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 13:03:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=d8CYNxy2ZGi1izKZ5P8ZDfyIJVJdAfK8YDAhIIQ6/9BOw0spJDc+oQYgAAWc1Kvf8eclhloyqkdO1HbX7MmExUn48b7xFbZdjblHHe1OSYAAcOwQRR2HXExTN7ZgpuLnpU4HPEs2EtyuBoe5Inn/2K50WWAowt4w+mRvLCK6XeQ=
To: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
Subject: Re: [PATCH 15/15] rfkill: document rw rfkill switches and clarify input subsystem interactions
Date: Tue, 20 May 2008 19:18:58 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, "Thomas Renninger" <trenn@suse.de>,
       "Dmitry Torokhov" <dtor@mail.ru>
References: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br> <200805201209.08986.IvDoorn@gmail.com> <1211298846.8328.1254165905@webmail.messagingengine.com>
In-Reply-To: <1211298846.8328.1254165905@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805201918.58709.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 May 2008, Henrique de Moraes Holschuh wrote:
> 
> On Tue, 20 May 2008 12:09:08 +0200, "Ivo van Doorn" <ivdoorn@gmail.com> said:
> > > +You should:
> > >  	- rfkill_allocate()
> > > -	- input_allocate_polled_device()
> > > +	- modify rfkill fields (flags, name)
> > > +	- modify state to the current hardware state (THIS IS THE ONLY TIME
> > > +	  YOU CAN ACCESS state DIRECTLY)
> > >  	- rfkill_register()
> > > -	- input_register_polled_device()
> > 
> > Wasn't it the plan to send the current hardware state as rfkill
> > registration argument,
> > so we can force drivers to send a valid state to rfkill?
> 
> Yes, but IMHO we should do that in a future patch.  That patch will touch
> every rfkill driver, so I'd rather we do that later.  IMHO it is best to get
> the most important stuff merged, first...
> 
> Then, in that future patch, we change the API, fix all in-tree drivers using
> that API, and update the documentation to match the new API.  For now, we
> update the documentation to match the current API.
> 
> What do you think?

Sounds good to me. :)

Ivo
