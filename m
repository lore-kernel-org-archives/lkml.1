Return-Path: <linux-kernel-owner+w=401wt.eu-S1753358AbYKHKPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbYKHKPY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 05:15:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbYKHKPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 05:15:10 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48911 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbYKHKPI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 05:15:08 -0500
Date: Sat, 8 Nov 2008 08:15:08 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Andre Kelmanson" <akelmanson@gmail.com>
Cc: "Hans Verkuil" <hverkuil@xs4all.nl>,
       "Markus Rechberger" <mrechberger@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       em28xx <em28xx@mcentral.de>, acano@fastmail.fm,
       "Bouwsma Barry" <freebeer.bouwsma@gmail.com>,
       "Dan Kreiser" <kreiser@informatik.hu-berlin.de>,
       "Frank Neuber" <fn@kernelport.de>,
       "Jelle de Jong" <jelledejong@powercraft.nl>,
       "John Stowers" <john.stowers.lists@gmail.com>,
       "Lukas Kuna" <lukas.kuna@evkanet.net>,
       "Stefan Vonolfen" <stefan.vonolfen@gmail.com>,
       "Stephan Berberig" <s.berberig@arcor.de>,
       "Thomas Giesecke" <thomas.giesecke@ibgmbh-naumburg.de>,
       "Vitaly Wool" <vwool@ru.mvista.com>, "Zhenyu Wang" <zhen78@gmail.com>,
       v4l <video4linux-list@redhat.com>, linux-dvb@linuxtv.org,
       greg@kroah.com, "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/7] Adding empia base driver
Message-ID: <20081108081508.496f6582@pedra.chehab.org>
In-Reply-To: <a2aa6e3a0811072150t535e802cge3375a7b88ee6287@mail.gmail.com>
References: <d9def9db0810221414w5348acf3re31a033ea7179462@mail.gmail.com>
	<200811011459.17706.hverkuil@xs4all.nl>
	<20081102022728.68e5e564@pedra.chehab.org>
	<a2aa6e3a0811072150t535e802cge3375a7b88ee6287@mail.gmail.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Nov 2008 03:50:20 -0200
"Andre Kelmanson" <akelmanson@gmail.com> wrote:

> Dears,
> 
> I'm using this version of em28xx for a long time and it's working fine. It
> has three very important features for me. The first one is Kaiomy device,
> the second one is the new em28xx-audoep module and the third one is PAL-M
> support. Kaiomy and PAL-M support were developed based on my support on the
> em28xx mailinglist.
> 
> Now I can use my device (Kaiomy) outside Windows with sound (em28xx-audioep)
> and colors (PAL-M)! I'm using this version everyday with no problems.
> 
> Because of this, it will be nice if this work could be included in the
> kernel code. What do you (other users) think about having that driver in
> kernel?

André,

First of all, the big issue why we aren't merging em28xx improvements from
Markus is that he is not following the rules.

For example, you said that you've contributed with Markus tree.

However, on Markus pull request, I see no patch from you on his series of patches. 

The correct procedure would be just to forward your patch as-is, adding with his SOB bellow yours.

Not doing this, he would be considered as the author of your patch. IANAL, but
this doesn't seem to be right, from GPL's perspective. Probably, there are
other patches there not authored by Markus that are just merged inside his big patch.

About PAL-M, this always worked at the upstream driver. I have myself lots of
em28xx devices, all working in colors with PAL-M, and with audio. I live in
Brazil, so I always check if PAL-M is ok ;)

If you want to have your device supported, just send us a patch against the
upstream driver.

Cheers,
Mauro
