Return-Path: <linux-kernel-owner+w=401wt.eu-S1755813AbYHTV2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813AbYHTV2t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 17:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753035AbYHTV2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 17:28:41 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57758 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751375AbYHTV2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 17:28:40 -0400
Date: Wed, 20 Aug 2008 17:28:39 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.27-rc2 USB suspend regression
In-Reply-To: <48AC8337.2070502@goop.org>
Message-ID: <Pine.LNX.4.44L0.0808201724380.14505-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Aug 2008, Jeremy Fitzhardinge wrote:

> Using the Fedora Rawhide kernel RPM "2.6.27-0.238.rc2.fc10.i686"
> (kernel-2.6.27-0.238.rc2.fc10.i686), I'm seeing suspend to ram
> failures.  The suspend seems to go OK, but then I just get endless:
> 
> usb 5-1: uhci_result_common: failed with status 440000
> 
> messages, with occasional flickers of something else being printed
> (perhaps).  The machine is otherwise unresponsive.

You could comment out that error message in order to see what else is 
in the log.  It is located in drivers/usb/host/uhci-q.c in the 
uhci_result_common() function.

You could try running -rc3 instead of -rc2, although that probably 
won't make much difference.

What USB devices do you have on the failing system?  In particular,
what is 5-1?  If you unplug it before suspending, does the problem go
away?  (It certainly should!)

Alan Stern

