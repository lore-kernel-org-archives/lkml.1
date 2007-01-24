Return-Path: <linux-kernel-owner+w=401wt.eu-S933095AbXAXBjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933095AbXAXBjj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 20:39:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933100AbXAXBji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 20:39:38 -0500
Received: from wx-out-0506.google.com ([66.249.82.238]:13947 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933095AbXAXBji convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 20:39:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mi72KBaYm4GNPSWxQ9jKMuEnJ020fuQ8ylTQGBxaY3sT06XZx+6kwDKjYNBV13NPSho6ROvUu0pdWELRKDXo2lMNdQH2sj6SlZWymuNswtfjtWcL1DSavOpA7OVRapqf1pMWTrBE0SueYMx8L6muJE15HBKnZ69fUp6qcZzs+9c=
Message-ID: <3877989d0701231739l1399afaci61aed9f26e3cd14@mail.gmail.com>
Date: Wed, 24 Jan 2007 09:39:37 +0800
From: "Luming Yu" <luming.yu@gmail.com>
To: "Lionel Landwerlin" <landwer@free.fr>
Subject: Re: 2.6.19.2 sky2/acpi crashes
Cc: "Len Brown" <lenb@kernel.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1169599541.5235.4.camel@cocoduo>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1169542768.5537.11.camel@cocoduo>
	 <3877989d0701230122r426eb5b0h446c897780923d7a@mail.gmail.com>
	 <1169555238.5747.3.camel@cocoduo> <200701231630.55096.lenb@kernel.org>
	 <1169599541.5235.4.camel@cocoduo>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/24/07, Lionel Landwerlin <landwer@free.fr> wrote:
> Le mardi 23 janvier 2007 à 16:30 -0500, Len Brown a écrit :
> > On Tuesday 23 January 2007 07:27, Lionel Landwerlin wrote:
> > > Le mardi 23 janvier 2007 à 17:22 +0800, Luming Yu a écrit :
> > > > Please try to remove processor module.
> > >
> > > Ok, that's done. Same problem.
> >
> > any difference with "idle=poll"?
> > if yes, how about "idle=halt"?
>
> idle=poll seems to fix the problem (cpu fan is running almost at full
> speed). Maybe I should run a longer test... For now it consists to run
> about 15 torrents and watching HDTV through ethernet device.
>
> idle=halt does not :

It sounds like issues relative to Processor C state.
Please enter a bug in ACPI category on bugzilla.kernel.org
