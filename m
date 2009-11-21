Return-Path: <linux-kernel-owner+w=401wt.eu-S1753751AbZKUXWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751AbZKUXWm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 18:22:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753308AbZKUXWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 18:22:41 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36175 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753211AbZKUXWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 18:22:40 -0500
Date: Sat, 21 Nov 2009 23:24:40 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: mfuzzey@gmail.com
Cc: linux-serial@vger.kernel.org, tsbogend@alpha.franken.de,
       linux-kernel@vger.kernel.org
Subject: Re: Serial: sc26xx device name
Message-ID: <20091121232440.68e9f68f@lxorguk.ukuu.org.uk>
In-Reply-To: <4B07F7E4.1070207@gmail.com>
References: <4B07F068.1090801@gmail.com>
	<20091121140911.0e7ef3fd@lxorguk.ukuu.org.uk>
	<4B07F7E4.1070207@gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Nov 2009 15:23:32 +0100
Martin Fuzzey <mfuzzey@gmail.com> wrote:

> Alan Cox wrote:
> >> 2) How are device name conflicts handled?
> >>     
> >
> > Badly - they should never occur but if someone didn't properly reserve
> > the namespace they can and then whoever forgot to reserve the namespace
> > loses.
> >   
> Currently this can't happen because the sc26xx driver uses ttySC205
> in contradiction to ttySC0 shown in devices.txt

I'd suggest that someone fixes it when it happens in that case. I doubt
it ever will.
