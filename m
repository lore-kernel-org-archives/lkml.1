Return-Path: <linux-kernel-owner+w=401wt.eu-S1751779AbXCIRS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779AbXCIRS7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 12:18:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752685AbXCIRS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 12:18:59 -0500
Received: from ns2.suse.de ([195.135.220.15]:35531 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751779AbXCIRS6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 12:18:58 -0500
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Subject: Re: refcounting drivers' data structures used in sysfs buffers
Date: Fri, 9 Mar 2007 18:18:56 +0100
User-Agent: KMail/1.9.1
Cc: "Alan Stern" <stern@rowland.harvard.edu>,
       "Maneesh Soni" <maneesh@in.ibm.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.0703091124570.2611-100000@iolanthe.rowland.org> <200703091745.00169.oneukum@suse.de> <d120d5000703090902v6ae88c75ibe18ff0de3e5276d@mail.gmail.com>
In-Reply-To: <d120d5000703090902v6ae88c75ibe18ff0de3e5276d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703091818.57456.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 9. März 2007 18:02 schrieb Dmitry Torokhov:

> I think we already have all refcounting that is needed. What is
> missing is subsystem-provided ->release() hooks for drivers to release
> driver-specific resources when a device finally goes away.

This is an interesting idea. Is it nice to pass through release()
but not open() ?

	Regards
		Oliver
