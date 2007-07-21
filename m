Return-Path: <linux-kernel-owner+w=401wt.eu-S937218AbXGUIhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937218AbXGUIhs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 04:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757549AbXGUIhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 04:37:37 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:32823 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbXGUIhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 04:37:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JrsiFMxeqHg17pXI487hYYTrnbxHZjh6yUhGc8esJarQRucNLa2vQ8BupPiuH152tSRXhme2K3mi2Xb9tfmjVvNp+N+qsdW8bEuOSmM4DOEQ8ur3bIIB2RdhYVFnhsJvpaUCGJnNTqV4bwojuegd+xM2XAY0qH2BRzozsjKEYNs=
Message-ID: <8bd0f97a0707210137j186554b6tb22e7f36237e862f@mail.gmail.com>
Date: Sat, 21 Jul 2007 04:37:35 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Robert Schwebel" <r.schwebel@pengutronix.de>
Subject: Re: blackfin - cmpxchg not atomic ?
Cc: "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>, tonyko@lineo.ca,
       robin.getz@analog.com, linux-kernel@vger.kernel.org
In-Reply-To: <20070721072930.GS1678@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070720202807.GA15009@Krystal>
	 <8bd0f97a0707201336l6bed7c24i7014333ce356417f@mail.gmail.com>
	 <20070721072930.GS1678@pengutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/21/07, Robert Schwebel <r.schwebel@pengutronix.de> wrote:
> On Fri, Jul 20, 2007 at 04:36:12PM -0400, Mike Frysinger wrote:
> > > Also, does you assembly stub _really_ modify memory atomically ? If yes,
> > > then there should be no need for disabling interrupts. Else, I see a
> > > major problem with SMP.
> >
> > that isnt the only problem with SMP on Blackfin
>
> Could you ealborate?

i'm pretty sure there's already been a thread on LKML about it ... the
fact that our parts currently lack any sort of cache snooping or
control over any other is a huge issue.

we've contracted a company to do SMP, but it'll have quite a bit of
overhead since it'll need to do a lot of communication/message passing
between cores to account for these hardware deficiencies.
-mike
