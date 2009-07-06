Return-Path: <linux-kernel-owner+w=401wt.eu-S1754074AbZGFWj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbZGFWj5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 18:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbZGFWjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 18:39:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57515 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554AbZGFWjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 18:39:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: 2.6.30-rc1: touchpad disabled on hibernation
Date: Tue, 7 Jul 2009 00:40:14 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc1-rjw; KDE/4.2.4; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-input@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
References: <4A438BA7.9010800@tuffmail.co.uk> <8db1092f0906251016l5ac85bfdpbac841b939cfac2a@mail.gmail.com> <4A43B1FC.7060609@tuffmail.co.uk>
In-Reply-To: <4A43B1FC.7060609@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907070040.14796.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 June 2009, Alan Jenkins wrote:
> Maciej Rutecki wrote:
> > 2009/6/25 Alan Jenkins <alan-jenkins@tuffmail.co.uk>:
> >   
> >> The synaptics touchpad on my EeePC 701 dies on hibernation.  2.6.30 was
> >> fine, and it doesn't happen on suspend to ram either.  There are no
> >> obvious error messages, but maybe this boot message is relevant:
> >>
> >> Platform driver 'i8042' needs updating, please use dev_pm_ops
> >>
> >>     
> >
> > Similar on s2disk, HP/Compaq notebook. Try reload psmouse module. I
> > reported it, but nobody answer.
> >   
> That works, thanks.

Alan, Maciej, can you both try the patch at
http://patchwork.kernel.org/patch/34075/, please?

Rafael
