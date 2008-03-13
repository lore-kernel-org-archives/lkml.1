Return-Path: <linux-kernel-owner+w=401wt.eu-S1754600AbYCMLBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbYCMLBW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 07:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbYCMLBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 07:01:15 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:42286 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbYCMLBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 07:01:14 -0400
Date: Thu, 13 Mar 2008 12:01:41 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Cc: stern@rowland.harvard.edu, linux-usb@vger.kernel.org, oliver@neukum.name
Subject: 2.6.25 -- long standing bug with usb after resume with 4GB ram
Message-ID: <20080313110141.GA4329@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

There are problems with usb after suspend/resume... it works as long
as memory is limited to 3G -- probably because iommu/agpgart/something
is not used in such case.

rmmod/insmod of ehci_hcd & ohci_hcd fixes that.

For testing with 2.6.25, you'll need aperture_64.c patch that makes
iommu as nosave (or it oopses).

Problem is also present in opensuse10.3.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
