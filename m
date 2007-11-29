Return-Path: <linux-kernel-owner+w=401wt.eu-S1761654AbXK2HxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761654AbXK2HxV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 02:53:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761150AbXK2HxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 02:53:00 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760880AbXK2Hw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 02:52:58 -0500
Date: Wed, 28 Nov 2007 23:52:37 -0800
From: Pete Zaitcev <zaitcev@redhat.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-usb@vger.kernel.org, preining@logic.at, kristoffer.ericson@gmail.com,
       drussell@redhat.com, johann.wilhelm@student.tugraz.at,
       linux-kernel@vger.kernel.org, zaitcev@redhat.com
Subject: Re: Add the infamous Huawei E220 to option.c
Message-Id: <20071128235237.152753e0.zaitcev@redhat.com>
In-Reply-To: <200711290839.00625.oliver@neukum.org>
References: <20071128161305.b01167b3.zaitcev@redhat.com>
	<200711290839.00625.oliver@neukum.org>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007 08:38:59 +0100, Oliver Neukum <oliver@neukum.org> wrote:

> Am Donnerstag, 29. November 2007 01:13:05 schrieb Pete Zaitcev:
> > The problem stems from the fact that both option and usb-storage can bind
> > to the modem when in storage mode: the former binds because of the storage
> > class, the latter binds because of VID/PID match. The modprobe loads both,
> 
> Isn't it possible to fix this in option's module table?

At first thought it'll need adding a field to struct usb_serial to save
the driver_info from the ID table in usb_serial_probe. It's something I'd
like to discuss actually. I hate fields which store information this
way: filled in one place, used in another place... From the perspective
of code prettiness I would rather add another method for usb_serial_probe
to call. But I'm not sure really.

-- Pete
