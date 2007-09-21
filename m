Return-Path: <linux-kernel-owner+w=401wt.eu-S1760729AbXIUPQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760729AbXIUPQR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 11:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751381AbXIUPQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 11:16:11 -0400
Received: from twin.jikos.cz ([213.151.79.26]:49940 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097AbXIUPQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 11:16:10 -0400
Date: Fri, 21 Sep 2007 17:15:58 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: USB autosuspend and turning of usb pendrive leds
In-Reply-To: <46F3D326.6050804@hhs.nl>
Message-ID: <Pine.LNX.4.64.0709211715250.22331@twin.jikos.cz>
References: <46F3C704.5000203@hhs.nl> <Pine.LNX.4.64.0709211615520.22331@twin.jikos.cz>
 <46F3D326.6050804@hhs.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2007, Hans de Goede wrote:

> Thats not what I had in mind, autosuspend doesn't work (presumably 
> because hal keeps polling for media change) maybe I should fix hal to 
> not keep polling for devices which don't have removable media?

Hi Hans,

I think the correct solution is that HAL stops polling the device as soon 
as it sees that it got autosuspended.

-- 
Jiri Kosina
