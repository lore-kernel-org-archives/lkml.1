Return-Path: <linux-kernel-owner+w=401wt.eu-S933606AbYCEBPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933606AbYCEBPr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 20:15:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756845AbYCEBPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 20:15:36 -0500
Received: from ns2.g-housing.de ([81.169.133.75]:58625 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755645AbYCEBPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 20:15:35 -0500
Date: Wed, 5 Mar 2008 02:15:20 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: David Brownell <david-b@pacbell.net>
cc: Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>, 0x0007@gmail.com,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: WARNING: at drivers/usb/host/ehci-hcd.c:287
In-Reply-To: <200803041630.11832.david-b@pacbell.net>
Message-ID: <alpine.DEB.1.00.0803050215140.7069@sheep.housecafe.de>
References: <Pine.LNX.4.44L0.0803041553320.15986-100000@iolanthe.rowland.org> <200803041401.41880.david-b@pacbell.net> <alpine.DEB.1.00.0803050012090.5974@sheep.housecafe.de> <200803041630.11832.david-b@pacbell.net>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2008, David Brownell wrote:
> Carrying that WARN_ON forward was inappropriate, so
> removing it is a safe thing to do.

OK, fine with me. Removing the WARN_ON "fixed" this particular issue, so 
feel free to close http://bugzilla.kernel.org/show_bug.cgi?id=10168 :)

> There are other lurking issues though.

uuh...let's hope they don't wake up?

thanks,
C.
-- 
BOFH excuse #238:

You did wha... oh _dear_....
