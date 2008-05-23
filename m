Return-Path: <linux-kernel-owner+w=401wt.eu-S1754800AbYEWQjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbYEWQjW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 12:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbYEWQjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 12:39:03 -0400
Received: from lap75545.ornl.gov ([160.91.210.54]:38668 "EHLO
	lap75545.ornl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbYEWQjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 12:39:01 -0400
Subject: Re: [PATCH 1/3] firmware: allow firmware files to be built into
	kernel image
From: David Dillow <dave@thedillows.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       aoliva@redhat.com, alan@lxorguk.ukuu.org.uk,
       Abhay Salunke <Abhay_Salunke@dell.com>, kay.sievers@vrfy.org,
       Haroldo Gamal <gamal@alternex.com.br>, Takashi Iwai <tiwai@suse.de>
In-Reply-To: <20080523162101.GA31107@uranus.ravnborg.org>
References: <1211550282.28967.8.camel@pmac.infradead.org>
	 <20080523162101.GA31107@uranus.ravnborg.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 23 May 2008 12:37:14 -0400
Message-Id: <1211560634.30637.16.camel@lap75545.ornl.gov>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-05-23 at 18:21 +0200, Sam Ravnborg wrote:
> But do we need the firmware after init?
> In other owrds could it be inside a discard after init block?

I think that'll depend on the device. The typhoon NIC driver needs its
firmware on 'ifconfig eth? up', and on resume, so it will need it after
we discard the init block. I expect others will need it at the very
least for resume.

Not that I'm using firmware loader for it right now, but it's been on my
TODO list for ages...

Dave
