Return-Path: <linux-kernel-owner+w=401wt.eu-S1753449AbYEWQit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbYEWQit (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 12:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750931AbYEWQim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 12:38:42 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:53819 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750696AbYEWQim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 12:38:42 -0400
Date: Fri, 23 May 2008 12:38:41 -0400
To: Sam Ravnborg <sam@ravnborg.org>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       aoliva@redhat.com, alan@lxorguk.ukuu.org.uk,
       Abhay Salunke <Abhay_Salunke@dell.com>, kay.sievers@vrfy.org,
       Haroldo Gamal <gamal@alternex.com.br>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 1/3] firmware: allow firmware files to be built into kernel image
Message-ID: <20080523163841.GC27128@csclub.uwaterloo.ca>
References: <1211550282.28967.8.camel@pmac.infradead.org> <20080523162101.GA31107@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080523162101.GA31107@uranus.ravnborg.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2008 at 06:21:01PM +0200, Sam Ravnborg wrote:
> Looks good.
> But do we need the firmware after init?
> In other owrds could it be inside a discard after init block?

What is you can hotplug the device and hence need to initialize the same
device type multiple times?  Wouldn't keeping the firmware around be
useful then?  How about on suspend/resume, do you need to reload
firmware in those cases?

-- 
Len Sorensen
