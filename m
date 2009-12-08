Return-Path: <linux-kernel-owner+w=401wt.eu-S936967AbZLHXH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936967AbZLHXH5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 18:07:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936856AbZLHXH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 18:07:56 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:50554 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936457AbZLHXH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 18:07:56 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Dave Airlie <airlied@redhat.com>
Subject: Re: [BISECTED] drm: random hang since 620f378 "drm: prune modes when ..."
Date: Wed, 9 Dec 2009 00:07:45 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Adam Jackson <ajax@redhat.com>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net
References: <200912071830.14697.arnd@arndb.de> <200912082259.48715.arnd@arndb.de> <1260310432.12969.0.camel@t60prh>
In-Reply-To: <1260310432.12969.0.camel@t60prh>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200912090007.45545.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19g9PZf+CXChdSMZogm6OPXJ/k4AK0IRV01vZO
 F1wBDnIwAxdj8s2+NVZQmZHNP0a6Vebb6B8QXhlCmiQPxIDZH1
 R6sPjRCZ6r7ga8l6SU3nQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 December 2009, Dave Airlie wrote:
> > 
> > Sorry for blaming the wrong patch, especially if it already caused a lot 
> > of work. I'll try blaming ec2a4c3fdc8 "drm/i915: get the bridge device
> > once" now, that is the next-best candidate that my bisection pointed to,
> > but I'll do more rigorous testing.

It just crashed again with both 620f378 and ec2a4c3fdc8 reverted as well, 
after about an hour of uptime.

> Btw is this just a laptop with no monitor plugged in?
> 
> just want to rule out the patch you mentioned for any sort of memory
> corruption.

It's a desktop machine with three outputs, Asus P5Q-EM mainboard.
VGA is not connected at all, DVI has an open-ended cable on it, i.e. no
screen on it. HDMI is connected through a cheap passive HDMI multiswitch
to the DVI-D input of a Lenovo screen.

	Arnd
