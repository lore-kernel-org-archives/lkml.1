Return-Path: <linux-kernel-owner+w=401wt.eu-S1756952AbZLDQQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952AbZLDQQJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 11:16:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756638AbZLDQQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 11:16:08 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:50707 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344AbZLDQQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 11:16:07 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] Driver core: fix race in dev_driver_string
Date: Fri, 4 Dec 2009 17:16:19 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-rc6-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, stable@kernel.org,
       Rickard Bellini <rickard.bellini@ericsson.com>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       Torgny Johansson <torgny.johansson@ericsson.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0912041102590.3070-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0912041102590.3070-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912041716.19329.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 4. Dezember 2009 17:06:57 schrieb Alan Stern:
> Oliver:
> 
> We don't have to worry about the device structure being deallocated 
> while the routine is running.  If that happens it's a bug in the 
> caller: improper refcounting.

That raises two points

1. am I supposed to get a reference just so that I can use dev_err?
2. what happens if this is a soft disconnect and the device is reconnected?
It seems to me that you'd print the wrong driver's name.

	Regards
		Oliver
