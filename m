Return-Path: <linux-kernel-owner+w=401wt.eu-S1756929AbYCMU2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929AbYCMU2f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 16:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865AbYCMU17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 16:27:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50140 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503AbYCMU15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 16:27:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: 2.6.25 -- long standing bug with usb after resume with 4GB ram
Date: Thu, 13 Mar 2008 21:27:10 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
       oliver@neukum.name
References: <20080313110141.GA4329@elf.ucw.cz>
In-Reply-To: <20080313110141.GA4329@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803132127.10896.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 13 of March 2008, Pavel Machek wrote:
> Hi!
> 
> There are problems with usb after suspend/resume... it works as long
> as memory is limited to 3G -- probably because iommu/agpgart/something
> is not used in such case.
> 
> rmmod/insmod of ehci_hcd & ohci_hcd fixes that.
> 
> For testing with 2.6.25, you'll need aperture_64.c patch that makes
> iommu as nosave (or it oopses).

Any chance to push that one upstream?

Rafael
