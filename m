Return-Path: <linux-kernel-owner+w=401wt.eu-S1758782AbXEMR4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758782AbXEMR4R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 13:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753827AbXEMR4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 13:56:07 -0400
Received: from main.gmane.org ([80.91.229.2]:46292 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152AbXEMR4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 13:56:05 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Matthieu CASTET <castet.matthieu@free.fr>
Subject: Re: [patch] make pit clocksource continuous
Date: Sun, 13 May 2007 17:55:45 +0000 (UTC)
Message-ID: <pan.2007.05.13.17.55.45@free.fr>
References: <46464B5C.2080302@aknet.ru>
	<1179040612.22481.237.camel@localhost.localdomain>
	<4646D493.9000309@aknet.ru>
	<1179068094.22481.248.camel@localhost.localdomain>
	<46474175.7030205@aknet.ru>
	<1179075026.22481.273.camel@localhost.localdomain>
	<46474975.1080204@aknet.ru>
	<1179077772.22481.279.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: cac94-1-81-57-151-96.fbx.proxad.net
User-Agent: Pan/0.125 (Potzrebie)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, 13 May 2007 19:36:12 +0200, Thomas Gleixner wrote:

> On Sun, 2007-05-13 at 21:23 +0400, Stas Sergeev wrote:
>> Hello.
>> 
>> Thomas Gleixner wrote:
>> >> Does this mean that on even an older
>> >> boards (without acpi at all) the hrtimers won't work?
>> > Not if PIT is the only clocksource available.
>> So you mean it can work without both the pm_timer and hpet? Sorry for
>> bothering you too much, but I am trying to use the hrtimers in my
>> driver module, so I'd like to know all the corner-cases.
> 
> It does _NOT_ work without pm_timer or hpet for the reasons explained
> before.
there something I don't understand : "pm_timer or hpet" aren't 
clockevent ?

Without acpi there should be still pit and tsc as clocksource ?

Also while talking about clockevent why rtc couldn't be used for that ?


Thanks

Matthieu

