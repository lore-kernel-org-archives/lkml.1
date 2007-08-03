Return-Path: <linux-kernel-owner+w=401wt.eu-S1761981AbXHCMEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761981AbXHCMEn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 08:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbXHCMEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 08:04:36 -0400
Received: from 78-32-9-130.no-dns-yet.enta.net ([78.32.9.130]:52290 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbXHCMEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 08:04:35 -0400
Date: Fri, 3 Aug 2007 13:04:18 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-usb-devel@lists.sourceforge.net,
       David Brownell <david-b@pacbell.net>, Greg KH <gregkh@suse.de>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org
Message-ID: <20070803120418.GB16802@srcf.ucam.org>
References: <Pine.LNX.4.44L0.0708022240250.1043-100000@netrider.rowland.org> <200708022301.08719.david-b@pacbell.net> <20070803112824.GA16802@srcf.ucam.org> <200708031344.03282.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708031344.03282.oliver@neukum.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [linux-usb-devel] [PATCH] USB: Only enable autosuspend by default on certain device classes
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2007 at 01:44:02PM +0200, Oliver Neukum wrote:
> Am Freitag 03 August 2007 schrieb Matthew Garrett:
> > It's certainly possible to do that, but it's also possible to have a 
> > userspace solution that whitelists devices. The question is whether the 
> > default kernel behaviour should be "Save power, but potentially break 
> > some of my devices" or "Don't break my devices, but use some more 
> > powre".
> 
> If both options have drawbacks, IMHO we follow the standard, which
> says that devices must support suspension.

Except that lots of hardware doesn't follow the standard in this 
respect, otherwise we wouldn't be having this discussion. Personally, I 
think "Will break an unknown number of devices" is a significantly 
larger drawback than "Will consume a small quantity of additional 
power".

-- 
Matthew Garrett | mjg59@srcf.ucam.org
