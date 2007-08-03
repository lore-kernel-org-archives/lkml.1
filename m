Return-Path: <linux-kernel-owner+w=401wt.eu-S1761348AbXHCLlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761348AbXHCLlz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 07:41:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758268AbXHCLls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 07:41:48 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:40062 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401AbXHCLlr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 07:41:47 -0400
From: Oliver Neukum <oliver@neukum.org>
To: linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] [PATCH] USB: Only enable autosuspend by default on certain device classes
Date: Fri, 3 Aug 2007 13:44:02 +0200
User-Agent: KMail/1.9.7
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       David Brownell <david-b@pacbell.net>, Greg KH <gregkh@suse.de>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.0708022240250.1043-100000@netrider.rowland.org> <200708022301.08719.david-b@pacbell.net> <20070803112824.GA16802@srcf.ucam.org>
In-Reply-To: <20070803112824.GA16802@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708031344.03282.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 03 August 2007 schrieb Matthew Garrett:
> On Thu, Aug 02, 2007 at 11:01:08PM -0700, David Brownell wrote:
> 
> > Seems to me it ought to be practical to organize a database that can
> > be consulted by an outcall from udev, disabling autosuspend on devices
> > which are known to be broken.  The "modules.usbmap" syntax is an obvious
> > place to start (painful though it is), and I'm sure there are folk who
> > would prefer web-accessible/updatable databases.
> 
> It's certainly possible to do that, but it's also possible to have a 
> userspace solution that whitelists devices. The question is whether the 
> default kernel behaviour should be "Save power, but potentially break 
> some of my devices" or "Don't break my devices, but use some more 
> powre".

If both options have drawbacks, IMHO we follow the standard, which
says that devices must support suspension.

	Regards
		Oliver

