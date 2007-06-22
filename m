Return-Path: <linux-kernel-owner+w=401wt.eu-S1758951AbXFVWBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758951AbXFVWBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 18:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753209AbXFVWBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 18:01:10 -0400
Received: from wr-out-0506.google.com ([64.233.184.238]:44677 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123AbXFVWBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 18:01:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=USDfZ2PRXaVfBXcg7kK5p/Mh7q080LURivatPlSXDzzPJECRkHW6wUdKMRNlajcSCHA4bmlzLdDhlAisSIyUyV4e7/QpWHw7+ZC0Ogh9E4YZAtuYaa9Y6ojas6b1lWyWHGTP9o+bDHJ0BLJWo1ISEDzq07KhqVe7HxYDFCigmAc=
Message-ID: <a781481a0706221501s4887f88bh3b8cc549deb6886e@mail.gmail.com>
Date: Sat, 23 Jun 2007 03:31:07 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Roman Zippel" <zippel@linux-m68k.org>
Subject: Re: Kconfig troubles when using menuconfig - Was: [patch]Re: [linux-usb-devel] linux-2.6.22-rc5-gf1518a0 build #300 failed in zc0301_core.c
Cc: "Trent Piepho" <xyzzy@speakeasy.org>,
       "Mauro Carvalho Chehab" <mchehab@infradead.org>, toralf.foerster@gmx.de,
       "Oliver Neukum" <oneukum@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       "Luca Risolia" <luca.risolia@studio.unibo.it>
In-Reply-To: <Pine.LNX.4.64.0706222336210.1817@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200706211117.55908.toralf.foerster@gmx.de>
	 <200706211231.53898.luca.risolia@studio.unibo.it>
	 <200706211326.45031.toralf.foerster@gmx.de>
	 <200706211350.14526.oneukum@suse.de>
	 <1182518566.14289.20.camel@gaivota>
	 <Pine.LNX.4.58.0706221259500.4914@shell4.speakeasy.net>
	 <a781481a0706221420u6935e75er1ee5601e013b40d2@mail.gmail.com>
	 <Pine.LNX.4.64.0706222336210.1817@scrub.home>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roman,

On 6/23/07, Roman Zippel <zippel@linux-m68k.org> wrote:
> Hi,
>
> On Sat, 23 Jun 2007, Satyam Sharma wrote:
>
> > given "menuconfig FOO depends on BAR", then all the "config BAZ"s
> > inside this menuconfig also automatically "depend on" BAR too.
> > This is simpler in the long run because it requires least amount
> > (actually none) of redundant typing
>
> I don't like this, as this would attach special meaning to a menuconfig.

But "menuconfig" _is_ special ...

> menuconfig is really a type of config symbol, rather than a type of menu.

Well, I'd have to disagree here. A config symbol has code associated
with it (at least _all_ config symbols in the kernel originally did, till
when these "menuconfig" things got introduced, which is precisely
what made them "special").

These "menuconfig" things are (or were supposed to be, at least :-)
just a _presentation_ thing.

> Potentially this could also be written as:
>
> config FOO
>         option menu
>         ...

I'm not sure why anybody would prefer such a syntax / idiom.
I know that "de gustibus non est disputandum", but personally
I find such usage *horribly* unclear.

Satyam
