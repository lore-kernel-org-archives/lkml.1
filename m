Return-Path: <linux-kernel-owner+w=401wt.eu-S1752503AbXBFDqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503AbXBFDqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 22:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752606AbXBFDqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 22:46:19 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:37395 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752503AbXBFDqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 22:46:18 -0500
Date: Tue, 6 Feb 2007 04:46:20 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Len Brown <lenb@kernel.org>
Cc: Berthold Cogel <cogel@rrz.uni-koeln.de>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: Regression in kernel linux-2.6.20-rc1/2: Problems with poweroff
Message-ID: <20070206034620.GB27397@stusta.de>
References: <459069AA.20809@rrz.uni-koeln.de> <45999C47.40204@rrz.uni-koeln.de> <20070102190722.GT20714@stusta.de> <200702052228.34264.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702052228.34264.lenb@kernel.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 05, 2007 at 10:28:34PM -0500, Len Brown wrote:
> > On Tue, Jan 02, 2007 at 12:41:59AM +0100, Berthold Cogel wrote:
> 
> > > >> 'shutdown -h now' doesn't work for my system (Acer Extensa 3002 WLMi)
> > > >> with linux-2.6.20-rc kernels. The system reboots instead.
> > > >> I've checked linux-2.6.19.1 with an almost identical .config file
> > > >> (differences because of new or changed options). For pre 2.6.20 kernels
> > > >> shutdown works for my computer.
> 
> Try CONFIG_USB=n

CONFIG_USB_SUSPEND=n is most likely enough.

That's an unfixed 2.6.20-rc regression reported more than once, the 
first time in December last year...

> http://bugzilla.kernel.org/show_bug.cgi?id=7945

http://bugzilla.kernel.org/show_bug.cgi?id=7828

> -Len

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

