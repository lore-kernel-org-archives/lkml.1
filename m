Return-Path: <linux-kernel-owner+w=401wt.eu-S1760697AbXK2ILg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760697AbXK2ILg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 03:11:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758477AbXK2ILY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 03:11:24 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758111AbXK2ILW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 03:11:22 -0500
Date: Thu, 29 Nov 2007 00:10:54 -0800
From: Pete Zaitcev <zaitcev@redhat.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-usb@vger.kernel.org, preining@logic.at, kristoffer.ericson@gmail.com,
       drussell@redhat.com, johann.wilhelm@student.tugraz.at,
       linux-kernel@vger.kernel.org
Subject: Re: Add the infamous Huawei E220 to option.c
Message-Id: <20071129001054.607488f4.zaitcev@redhat.com>
In-Reply-To: <200711290904.29761.oliver@neukum.org>
References: <20071128161305.b01167b3.zaitcev@redhat.com>
	<200711290839.00625.oliver@neukum.org>
	<20071128235237.152753e0.zaitcev@redhat.com>
	<200711290904.29761.oliver@neukum.org>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007 09:04:28 +0100, Oliver Neukum <oliver@neukum.org> wrote:

> > > Isn't it possible to fix this in option's module table?
> >
> > At first thought it'll need adding a field to struct usb_serial to save
> > the driver_info from the ID table in usb_serial_probe. It's something I'd
> 
> Why? It is passed to the subdrivers in their probe().
> Maybe it should simply be passed in attach(), too?

My bad, you're right. I'm just mentally dead now.

-- Pete
