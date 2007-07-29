Return-Path: <linux-kernel-owner+w=401wt.eu-S1763281AbXG2N6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763281AbXG2N6t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 09:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762207AbXG2N6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 09:58:41 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:18221 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521AbXG2N6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 09:58:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OXYiNm3xTAS4NGRritVdKRAK6lRX+ucIlDxMAfMnDQm7/VGDppyVptscccmr1XqdgStvYSrQgwayFN0+OuZuf7mYvJ0J5G6ptqY8w/sr/BHxhPXFPjgZZcUnyo68E1veukPi+oxJw6X50UML44I9OBoWvgo7y6M0Mg0quUZEIms=
Message-ID: <82e4877d0707290658y2861473fs3b10d9ddbe521401@mail.gmail.com>
Date: Sun, 29 Jul 2007 09:58:39 -0400
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Dmitry Torokhov" <dtor@insightbb.com>
Subject: Re: [PATCH] TSDEV - Don't flood dmesg with removal warnings
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org
In-Reply-To: <200707290037.37606.dtor@insightbb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0707271038100.5691@parag-desktop>
	 <200707290037.37606.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On 7/29/07, Dmitry Torokhov <dtor@insightbb.com> wrote:
> Hi Parag,
>
> On Friday 27 July 2007 10:43, Parag Warudkar wrote:
> > Ignore my previous whitespace damaged patch. This one should be good.
> >
> > tsdev.c warns about scheduled removal each time tsdev_open is called -
> > So even for a default boot I get to see the warning 3 times -
>
> The printk was moved per Andrew's request to make it more annoying.

The fact that tsdev loads on most people's laptop for no reason and
then gets opened 3 times ought to be annoying enough to make people
delete that module :)

> Obviously it is working ;) Do you know what is opening /dev/input/tsX
> nodes?
>

Who else but Xorg and the boat load of totally irrelevant crap (wacom
etc.) that Ubuntu fills up in xorg.conf (perhaps)? Frankly I don't
know for sure.

Anyway the stated removal is only 3 months away so I guess people can
live with the dmesg annoyance until that time.

Parag
