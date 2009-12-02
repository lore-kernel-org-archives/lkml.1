Return-Path: <linux-kernel-owner+w=401wt.eu-S1753631AbZLBJl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631AbZLBJl4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 04:41:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbZLBJlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 04:41:55 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:40018 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbZLBJly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 04:41:54 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: debugging oops after disconnecting Nexio USB touchscreen
Date: Wed, 2 Dec 2009 10:42:04 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-rc6-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.0912011005140.2983-100000@iolanthe.rowland.org> <200912020952.09354.linux@rainbow-software.org>
In-Reply-To: <200912020952.09354.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912021042.04557.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 2. Dezember 2009 09:52:08 schrieb Ondrej Zary:
> It shows "prev is NULL, qh=f6581080, ehci->async=f6581000".
> 
> The problem is that activating usbmon causes the problem to disappear. No
>  errors in maybe 15 attempts. It appeared on 2nd attempt after unloading
>  usbmon.

That suggests a use after free bug, which usbmon prevents holding
an additional reference.
Are you using SLAB_DEBUG?

	Regards
		Oliver
