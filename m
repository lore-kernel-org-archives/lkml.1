Return-Path: <linux-kernel-owner+w=401wt.eu-S1030599AbXDUKgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030599AbXDUKgX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 06:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932500AbXDUKgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 06:36:23 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:58342 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932184AbXDUKgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 06:36:22 -0400
Date: Sat, 21 Apr 2007 12:36:32 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Greg KH <gregkh@suse.de>
Cc: Marcos Pinto <markybob@gmail.com>, linux-kernel@vger.kernel.org,
       Jan Beulich <jbeulich@novell.com>, Alan Cox <alan@redhat.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: 2.6.20.7 locking up hard on boot
Message-ID: <20070421103632.GC4016@stusta.de>
References: <62eb359a0704201747ma376567kda671d6fa98b7409@mail.gmail.com> <20070421013454.GB4016@stusta.de> <62eb359a0704202130p39cf24efu89dccc8437c30d25@mail.gmail.com> <20070421053420.GA10974@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070421053420.GA10974@suse.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2007 at 10:34:20PM -0700, Greg KH wrote:
> On Fri, Apr 20, 2007 at 11:30:59PM -0500, Marcos Pinto wrote:
> >  Yes, I just tried 2.6.20.3 with ACPI enabled and it booted perfectly.
> >  I'm hoping this means you know what's wrong? :-)
> 
> Can you do a 'git bisect' on the versions between 2.6.20.3 and 2.6.20.7
> to try to find the problem patch?

Considering where it failed and that 2.6.20.3 worked, I would be 
extremely surprised if this wasn't one more report of 
adjust-legacy-ide-resource-setting.patch breaking booting (and we 
already have confirmed reports for this)...

But AFAIK we still don't understand how this patch managed to break 
things.

> thanks,
> 
> greg k-h

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

