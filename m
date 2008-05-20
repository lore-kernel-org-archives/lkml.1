Return-Path: <linux-kernel-owner+w=401wt.eu-S932648AbYETOS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932648AbYETOS2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 10:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755733AbYETOSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 10:18:20 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:37441 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634AbYETOST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 10:18:19 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Subject: Re: [Bug #10630] USB devices plugged into dock are not discoverred until reload of ehci-hcd
Date: Tue, 20 May 2008 16:18:13 +0200
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stern@rowland.harvard.edu, greg@kroah.com, linux-usb@vger.kernel.org
References: <20080520123423.GA4764@ics.muni.cz> <200805201440.47217.oliver@neukum.org> <20080520141132.GG4764@ics.muni.cz>
In-Reply-To: <20080520141132.GG4764@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805201618.14069.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 20 Mai 2008 16:11:32 schrieb Lukas Hejtmanek:
> On Tue, May 20, 2008 at 02:40:46PM +0200, Oliver Neukum wrote:
> > > > > http://bugzilla.kernel.org/show_bug.cgi?id=10630
> > > Hm, without USB_SUSPEND it works. So what next, considered fixed or any
> > > further investigation is needed?
> > 
> > It is by no means fixed!
> > 
> > Now we find out what exactly doesn't work. Please apply this patch
> > and provide "dmesg -c" before you plug in the device and after that.
> 
> Should I use USB_SUSPEND or not?

Yes, use USB_SUSPEND.

	Regards
		Oliver
