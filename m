Return-Path: <linux-kernel-owner+w=401wt.eu-S932402AbXHCPeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932402AbXHCPeG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 11:34:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762695AbXHCPdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 11:33:55 -0400
Received: from twin.jikos.cz ([213.151.79.26]:41600 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762625AbXHCPdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 11:33:55 -0400
Date: Fri, 3 Aug 2007 17:31:52 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Adam Kropelin <akropel1@rochester.rr.com>
cc: Dave Jones <davej@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Oliver Neukum <oliver@neukum.org>, Rogan Dawes <lists@dawes.za.net>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       David Brownell <david-b@pacbell.net>,
       Alan Stern <stern@rowland.harvard.edu>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] [PATCH] USB: Only enable autosuspend by default
 on certain device classes
In-Reply-To: <036a01c7d5e2$80add6b0$03c8a8c0@kroptech.com>
Message-ID: <Pine.LNX.4.64.0708031730180.26230@twin.jikos.cz>
References: <20070803140909.GA19245@srcf.ucam.org>
 <Pine.LNX.4.44L0.0708031014160.3416-100000@iolanthe.rowland.org>
 <20070803143338.GA19713@srcf.ucam.org> <Pine.LNX.4.64.0708031636160.26230@twin.jikos.cz>
 <20070803145321.GB17138@redhat.com> <036a01c7d5e2$80add6b0$03c8a8c0@kroptech.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Aug 2007, Adam Kropelin wrote:

> Although I have no proof immediately at hand, I suspect at a minimum HID 
> power class devices should be blacklisted from autosuspend. Given the 
> spotty USB implementations on many such devices I'd be surprised if 
> suspend worked reliably. 

I agree here.

> Plus if you're connected to such a device for monitoring purposes you're 
> probably powered by it as well, so you have little to gain from suspend 
> even if it works.

I currently don't have any HID UPS by hand to verify, but I'd be surprised 
if they would advertise remote wakeup capability ... ?

Thanks,

-- 
Jiri Kosina
