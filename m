Return-Path: <linux-kernel-owner+w=401wt.eu-S934238AbYETV7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934238AbYETV7X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 17:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763373AbYETV7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 17:59:13 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:35338 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757768AbYETV7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 17:59:12 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] Firmware loader driver for USB Apple iSight camera
Date: Tue, 20 May 2008 23:59:05 +0200
User-Agent: KMail/1.9.9
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, gregkh@suse.de,
       bersace03@laposte.net, johannes@sipsolutions.de
References: <20080520190628.GA14580@srcf.ucam.org>
In-Reply-To: <20080520190628.GA14580@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805202359.06873.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 20 Mai 2008 21:06:28 schrieb Matthew Garrett:
> I think this is a cleaner solution than adding support for the firmware 
> loading directly to the uvcvideo driver, and doing it as a driver rather 
> than a set of userspace callouts simplifies the suspend/resume case. The

How does that simplify suspend/resume?
If the device looses its firmware due to suspend you must implement
this support in uvc, or a user space driver will be as good as this solution.

	Regards
		Oliver

