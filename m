Return-Path: <linux-kernel-owner+w=401wt.eu-S1753181AbZLZVhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbZLZVhk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 16:37:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbZLZVhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 16:37:39 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58707 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427AbZLZVhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 16:37:38 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alexander Clouter <alex@digriz.org.uk>
Subject: Re: [RFT] Input: speed up suspend/shutdown for PS/2 mice and keyboards
Date: Sat, 26 Dec 2009 22:38:20 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
References: <20091221070951.GA4170@core.coreip.homeip.net> <magh07-258.ln1@chipmunk.wormnet.eu>
In-Reply-To: <magh07-258.ln1@chipmunk.wormnet.eu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <200912262238.20690.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 December 2009, Alexander Clouter wrote:
> Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > 
> > I am asking everyone to give this patch a try. It is reported to speed
> > up suspend process, however there is a risk that there are boxes out
> > there that do require full reset and I would prefer to know that sooner
> > than later.
> > 
> Seems to work on my ICH8 lapdog (a Fujitsu T2010), can't say it actually 
> speeds the suspend/resume cycle up though.

With 2.6.33-rc2, if you do

dmesg | grep "of devices"

that will give you total device suspend/resume times.  By comparing the times
with and without the patch you should be able to tell the difference (if any).

Rafael
