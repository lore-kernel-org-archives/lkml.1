Return-Path: <linux-kernel-owner+w=401wt.eu-S1757108AbZDCC7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108AbZDCC7Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 22:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026AbZDCC7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 22:59:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55884 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752258AbZDCC7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 22:59:17 -0400
Date: Thu, 2 Apr 2009 19:56:54 -0700
From: Greg KH <gregkh@suse.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: qcserial comes up in unhelpful custom mode?
Message-ID: <20090403025654.GA20146@suse.de>
References: <20090401203726.GA17485@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090401203726.GA17485@srcf.ucam.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 01, 2009 at 09:37:26PM +0100, Matthew Garrett wrote:
> The qcserial driver appears to bind with the device providing a "QDL" 
> interface, whatever that is. The internet suggests that the device needs 
> firmware loading before it'll do anything useful. Is there any code out 
> there to do this on Linux, or is the driver currently fairly useless?

I have a package from Qualcom, that dumps the firmware down into the
device.  It includes a udev rule and firmware images to get the modem
working.

Unfortunatly, the license on the code seems to be restricting its
redistribution at the moment, although I have been told this will change
in the future when some machines ship with Linux installed on them with
this hardware included.

But, I have heard reports of people dual-booting with other operating
systems and then successfully using the device under Linux with the
qcserial driver, so that is one solution for some users.

Sorry I don't have better news,

greg k-h
