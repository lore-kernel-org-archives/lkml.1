Return-Path: <linux-kernel-owner+w=401wt.eu-S1754781AbYKNToj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbYKNToj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 14:44:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbYKNTob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 14:44:31 -0500
Received: from mail-gx0-f11.google.com ([209.85.217.11]:43541 "EHLO
	mail-gx0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbYKNToa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 14:44:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=KxvW38rAoXdN7PifVk9mRdkZfg5qYj3ghtUzJx76Hlq5356bkOEgFMyfoH1tXGJ2ox
         PQXmx1r8TfwP4TyC1tAD9Ar5l/l2yWfv6JnDEU55nrbnMaQyqc23v78CMj8s+q/K3iTs
         nCpr5TbSQBS5r/nEReUuKI+Nh6SpQOYpFhif4=
Subject: Re: [v4l-dvb-maintainer] [PATCH] dvb: usb vendor_ids/product_ids
 are __le16
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
Cc: Michael Krufky <mkrufky@linuxtv.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       v4l-maintainer <v4l-dvb-maintainer@linuxtv.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <412bdbff0811141125x34de747dm85b47f61b604219a@mail.gmail.com>
References: <1226686796.5483.33.camel@brick> <491DCBDD.4000703@linuxtv.org>
	 <1226689669.5483.36.camel@brick>
	 <37219a840811141115g539ef85fo81136ebd479f016f@mail.gmail.com>
	 <1226690438.5483.39.camel@brick>
	 <412bdbff0811141125x34de747dm85b47f61b604219a@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 14 Nov 2008 11:44:25 -0800
Message-Id: <1226691865.5483.47.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-14 at 14:25 -0500, Devin Heitmueller wrote:
> > The alternative is to define the vendor ids as little-endian in the headers
> > then you don't need the endian swap in the switch or the case, but that would
> > require looking at the other uses first....or gently encourage more people to run sparse ;-)
> >
> > Harvey
> 
> Harvey,
> 
> If I may offer my opinion, this is not remotely performance-critical
> code.  That said, I would favor on the side of
> maintainability/reliability in this case, and mkrufky's approach seems
> to be better on both accounts.

Well, I can see your point, and I don't even know what the chances are of
even finding this hardware on a big-endian machine are.  But I'd suggest
that if you want to improve the maintainability of this code that someone
in v4l-land start running sparse regularly and work on getting some of these
_trivial_ parts annotated, then any new ones that get introduced will stick
out like sore thumbs.

But, not my driver, not my decision.  Someone else can implement Michael's
suggestion if they want.

Harvey


