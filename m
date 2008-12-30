Return-Path: <linux-kernel-owner+w=401wt.eu-S1753185AbYL3Nhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185AbYL3Nhu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 08:37:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037AbYL3Nhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 08:37:41 -0500
Received: from mail.ukfsn.org ([77.75.108.10]:34935 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032AbYL3Nhk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 08:37:40 -0500
Date: Tue, 30 Dec 2008 13:37:37 +0000
From: Nick Warne <nick@ukfsn.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>,
       Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.28: How come some kernel options cannot be disabled for
 non-existent hardware?
Message-ID: <20081230133737.3a44513e@sauron.linicks.net>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.9; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Dec 30, 2008 at 07:25:42AM -0500, Justin Piszcz wrote:
> 
> > It still shows up as enabled and it is in dmesg shown above.  How come 
> > some kernel options are enabled and cannot (easily?) be disabled for 
> > hardware that does not exist in my machine?
> 
> It's enabled by the ATA_ACPI support so libata can handle ACPI-based 
> drive hotswaps. You can check these by looking at the help for an option 
> in make menuconfig. That'll tell you what's selecting an option.

I have been battling this sort of thing lately.  In fact, the dock
option seems to get set with '& experimental'.  I got rid of it, but
that then buggered up the selection of k8temp which needs experimental.

Nick
-- 
Free Software Foundation Associate Member 5508
http://linicks.net/
