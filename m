Return-Path: <linux-kernel-owner+w=401wt.eu-S1753544AbYJ0Vwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbYJ0Vwo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 17:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751688AbYJ0Vwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 17:52:36 -0400
Received: from mail.suse.de ([195.135.220.2]:54258 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521AbYJ0Vwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 17:52:36 -0400
Date: Mon, 27 Oct 2008 22:52:33 +0100
From: Bernhard Walle <bwalle@suse.de>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Thomas Mingarelli <thomas.mingarelli@hp.com>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] [WATCHDOG] Fix kdump when using hpwdt
Message-ID: <20081027225233.34758cda@kopernikus.site>
In-Reply-To: <20081027193053.GA2659@infomag.infomag.iguana.be>
References: <1225033177-5311-1-git-send-email-bwalle@suse.de>
	<20081027193053.GA2659@infomag.infomag.iguana.be>
Organization: SUSE Linux Products GmbH
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wim,

* Wim Van Sebroeck [2008-10-27 20:30]:

> > -module_param(allow_kdump, int, 0);
> > +module_param(allow_kdump, int, 1);
> >  MODULE_PARM_DESC(allow_kdump, "Start a kernel dump after NMI occurs");
> 
> the syntax is: #define module_param(name, type, perm)
> perm sets the visibility in sysfs: 000 means it's not there,
> read bits mean it's readable, write bits mean it's writable.
> 
> perm is not the default value for the integer but a file permission attribute.

Yeah, thanks for spotting that. I was a bit in hurry while creating the
patch ...

I'll come up with an updated patch with the suggestions from Vivek.
Probably tomorrow.


Regards,
Bernhard
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Development
