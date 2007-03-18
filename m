Return-Path: <linux-kernel-owner+w=401wt.eu-S932780AbXCRSld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932780AbXCRSld (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 14:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932800AbXCRSld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 14:41:33 -0400
Received: from styx.suse.cz ([82.119.242.94]:60064 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932780AbXCRSlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 14:41:32 -0400
Date: Sun, 18 Mar 2007 19:45:06 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Soeren Sonnenburg <kernel@nn7.de>, Sergey Vlasov <vsu@altlinux.ru>,
       linux-input@atrey.karlin.mff.cuni.cz
Subject: Re: appletouch quirk doesn't run at resume
In-Reply-To: <20070318004240.GO752@stusta.de>
Message-ID: <Pine.LNX.4.64.0703181934530.4195@jikos.suse.cz>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
 <200703162134.14265.rjw@sisk.pl> <1174078066.13341.279.camel@localhost.localdomain>
 <1174087552.13341.332.camel@localhost.localdomain> <45FBBDEA.9060708@m3y3r.de>
 <20070318004240.GO752@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Mar 2007, Adrian Bunk wrote:

> > 1.) The quirk added in commit a417a21e10831bca695b4ba9c74f4ddf5a95ac06 
> >     for the appletouch driver doesn't seem to work after resume.
> Not a regression, but still a bug. Appropriate people added to the Cc.

(trimmed CC a little bit)

Thomas, could you please provide more information? Did it ever work for 
you after suspend/resume cycle and it just broke at some point in the 
past, or you are not sure whether it ever worked?

Also, what exactly does it mean that it doesn't work? Are both the 
interfaces after resume bound to usbhid driver (you can check this in 
/sys)? When the quirk works correctly, only the keyboard interface should 
be bound to usbhid driver. Please check the binding both before and after 
suspend/resume cycle, and let me know.

Thanks,

-- 
Jiri Kosina
