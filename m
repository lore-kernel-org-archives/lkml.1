Return-Path: <linux-kernel-owner+w=401wt.eu-S932096AbXCUBzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096AbXCUBzG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 21:55:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbXCUBzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 21:55:05 -0400
Received: from old-tantale.fifi.org ([64.81.251.130]:38723 "EHLO
	tantale.fifi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbXCUBzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 21:55:04 -0400
X-Greylist: delayed 684 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Mar 2007 21:55:03 EDT
To: Wakko Warner <wakko@animx.eu.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: scsi: Devices offlined
References: <20070321004830.GA4901@animx.eu.org>
Mail-Copies-To: nobody
From: Philippe Troin <phil@fifi.org>
Date: 20 Mar 2007 18:43:12 -0700
In-Reply-To: <20070321004830.GA4901@animx.eu.org>
Message-ID: <87ircv5q33.fsf@tantale.fifi.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Wakko Warner <wakko@animx.eu.org> writes:

> [84797.683873] sr 1:0:13:0: scsi: Device offlined - not ready after error recovery
> 
> Is there anyway to make the kernel "online" a device that has done this? 
> I've had this happen on various devices (mostly on usb where I can
> unplug/replug), but this time, it's on a scsi controller and the driver is
> not a module.
> 
> If it's possible to do this w/o rebooting, I'd like to know for when I have
> this happen in the future.

Have you tried:

  echo remove-single-device BUS ID LUN > /proc/scsi
  echo add-single-device BUS ID LUN > /proc/scsi

?

Phil.
