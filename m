Return-Path: <linux-kernel-owner+w=401wt.eu-S1760405AbZD0UX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760405AbZD0UX0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 16:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760107AbZD0UXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 16:23:09 -0400
Received: from outbound-mail-147.bluehost.com ([67.222.38.37]:41693 "HELO
	outbound-mail-147.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759710AbZD0UXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 16:23:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=TvaepnevjVE+C3WmxEwgRgqprYNtPt4dxvpJ9cBPijI+MHNT4g/IIYeazzmKcGkKXT3IZIc51Pi6OZcjbaWQ9688RcNErmEWWnidznlm2Gv+/TX4+2zdaBI7MUrSobea;
Date: Mon, 27 Apr 2009 13:18:07 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Niel Lambrechts <niel.lambrechts@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>, eric@anholt.net
Subject: Re: [Bug #13180] 2.6.30-rc2: WARNING at i915_gem.c for
 i915_gem_idle
Message-ID: <20090427131807.1999058c@hobbes>
In-Reply-To: <49F61143.9030501@gmail.com>
References: <47KgT3nlbjD.A.lnB.jc48JB@chimera>
	<Fg2zLW93smL.A.hKC.tc48JB@chimera>
	<20090427093847.778dcd81@hobbes>
	<49F61143.9030501@gmail.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Apr 2009 22:10:43 +0200
Niel Lambrechts <niel.lambrechts@gmail.com> wrote:
> Hi Jesse,
> 
> Sure thing - and to be complete I retried with the latest git kernel,
> along with the latest Xorg updates from the OPENSUSE 11.1 Xorg
> repository.
> 
> On my system the default displaymanager configuration contains
> DISPLAYMANAGER_RANDR_MODE_auto="1024x768_60 64.11 1024 1080 1184 1344
> 768 769 772 795 -HSync +Vsync"
> 
> With this setting running in KMS+UXA, kdm starts up with a garbled
> screen, and I soon get a soft lock-up after trying to blindly
> entering a username/password. With any other setting, I got the mouse
> cursor but soon followed by a black screen and soft lock-up (No
> activity from caps-lock, but Alt-SysRq still worked). These settings
> work fine without KMS when just using EXA.

Ooh that sounds bad.  Can you check out
http://intellinuxgraphics.org/how_to_report_bug.html and file a bug at
freedesktop.org for this?  That way we won't lose it, and we'll have
all the info in one place.

Eric, do you know of any changes recently that might affect the
gem_idle warning Niel sees here?  Seems like in any UMS config the GEM
lists should be clear at VT switch time...

-- 
Jesse Barnes, Intel Open Source Technology Center
