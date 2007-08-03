Return-Path: <linux-kernel-owner+w=401wt.eu-S1763666AbXHCQGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763666AbXHCQGT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 12:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762639AbXHCQGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 12:06:08 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:48159 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754595AbXHCQGG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 12:06:06 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [linux-usb-devel] [PATCH] USB: Only enable autosuspend by default on certain device classes
Date: Fri, 3 Aug 2007 18:08:11 +0200
User-Agent: KMail/1.9.7
Cc: David Brownell <david-b@pacbell.net>,
       linux-usb-devel@lists.sourceforge.net, Greg KH <gregkh@suse.de>,
       Rogan Dawes <lists@dawes.za.net>, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>
References: <Pine.LNX.4.44L0.0708022240250.1043-100000@netrider.rowland.org> <200708030737.56316.david-b@pacbell.net> <20070803150303.GA19968@srcf.ucam.org>
In-Reply-To: <20070803150303.GA19968@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708031808.11903.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 03 August 2007 schrieb Matthew Garrett:
> > Which is why I didn't suggest doing that, of course.  The only
> > one making that kind of straw man argument seems to be you.
> 
> But however you phrase it, that's effectively what it is. "Does your 
> device work?" just makes users wonder why the damn computer doesn't know 
> already. "This option may prevent your device from working. Click here 
> to switch it off" results in them wondering why it was switched on in 
> the first place. Many of our users aren't technical - they don't care 
> about saving 200mW, they just care about their printer working when they 
> plug it in.

Devices rarely simply crash. Although Windows doesn't do runtime power
management, it certainly will suspend all devices when the system goes
into suspension. Buggy devices typically disconnect and reconnect when
resumed. This is testable for in software without user intervention.

	Regards
		Oliver

