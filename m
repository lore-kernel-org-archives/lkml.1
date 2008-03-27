Return-Path: <linux-kernel-owner+w=401wt.eu-S1757540AbYC0C6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540AbYC0C6t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 22:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755205AbYC0C6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 22:58:39 -0400
Received: from netrider.rowland.org ([192.131.102.5]:1055 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754966AbYC0C6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 22:58:38 -0400
Date: Wed, 26 Mar 2008 22:58:37 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Greg KH <greg@kroah.com>
cc: mark gross <mgross@linux.intel.com>, lkml <linux-kernel@vger.kernel.org>,
       <linux-rt-users@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: Real time USB2Serial devices and behaivor
In-Reply-To: <20080326232419.GC15468@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0803262255320.21714-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2008, Greg KH wrote:

> > Is there any reason to think that if I created my own isochronous
> > USB2Serial adapter and iso-usb-driver that I couldn't get determinism?
> 
> I strongly doubt it as others have tried and failed in the past.

I don't understand.  Isochronous transfers have pretty strict 
transfer-time guarantees.  Why wouldn't this work?

One reason I can think of is that Iso transfers aren't reliable.  But
then regular RS232-type serial transfers aren't reliable either.

The only other reason is that the USB stack itself has an unpredictable 
amount of overhead.  However I think it should fall within an 
acceptable range for RT applications.

Alan Stern

