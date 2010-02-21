Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab0BUWKS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 17:10:18 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:38539 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076Ab0BUWKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 17:10:15 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [REGRESSION] "USB: use kfifo to buffer usb-generic serial writes" causes gobi_loader to hang
Date: Sun, 21 Feb 2010 23:09:57 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc8-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Anssi Hannula <anssi.hannula@iki.fi>,
       Matthew Garrett <mjg59@srcf.ucam.org>, dvomlehn@cisco.com,
       gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.1002211627430.32083-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1002211627430.32083-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002212309.57715.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 21. Februar 2010 22:28:54 schrieb Alan Stern:
> > > This is again with the gobi_loader with extra sleep added in the beginning. 
> > > Otherwise it hangs (which is the actual original problem).
> > 
> > That log makes sure that the final cancellation comes from closing
> > the file. Is that a log of a working run?
> 
> Could this simply be one of those cases where the device file is closed 
> just after the final write URB is submitted but before it can complete, 
> so the URB gets cancelled and the data isn't transferred?

It looks likely, but why doesn't a delay fix it?

	Regards
		Oliver
