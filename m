Return-Path: <linux-kernel-owner+w=401wt.eu-S1763365AbXHCUKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763365AbXHCUKy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 16:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757681AbXHCUKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 16:10:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758221AbXHCUKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 16:10:44 -0400
Date: Fri, 3 Aug 2007 16:03:36 -0400
From: Dave Jones <davej@redhat.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       linux-usb-devel@lists.sourceforge.net, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       Alan Stern <stern@rowland.harvard.edu>,
       Rogan Dawes <lists@dawes.za.net>
Subject: Re: [linux-usb-devel] [PATCH] USB: Only enable autosuspend by
	default on certain device classes
Message-ID: <20070803200336.GA20376@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Oliver Neukum <oliver@neukum.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	linux-usb-devel@lists.sourceforge.net, Greg KH <gregkh@suse.de>,
	linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
	Alan Stern <stern@rowland.harvard.edu>,
	Rogan Dawes <lists@dawes.za.net>
References: <Pine.LNX.4.44L0.0708022240250.1043-100000@netrider.rowland.org> <200708030737.56316.david-b@pacbell.net> <20070803150303.GA19968@srcf.ucam.org> <200708031808.11903.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200708031808.11903.oliver@neukum.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2007 at 06:08:11PM +0200, Oliver Neukum wrote:
 > Am Freitag 03 August 2007 schrieb Matthew Garrett:
 > > > Which is why I didn't suggest doing that, of course.  The only
 > > > one making that kind of straw man argument seems to be you.
 > > 
 > > But however you phrase it, that's effectively what it is. "Does your 
 > > device work?" just makes users wonder why the damn computer doesn't know 
 > > already. "This option may prevent your device from working. Click here 
 > > to switch it off" results in them wondering why it was switched on in 
 > > the first place. Many of our users aren't technical - they don't care 
 > > about saving 200mW, they just care about their printer working when they 
 > > plug it in.
 > 
 > Devices rarely simply crash. Although Windows doesn't do runtime power
 > management, it certainly will suspend all devices when the system goes
 > into suspension. Buggy devices typically disconnect and reconnect when
 > resumed. This is testable for in software without user intervention.

The printer I mentioned earlier this thread wouldn't work again
until I physically unplugged and replugged the usb cable.
It spewed descriptor read errors every time I tried to talk to it.
Even unloading and reloading the usb modules didn't bring it back
to life.

	Dave

-- 
http://www.codemonkey.org.uk
