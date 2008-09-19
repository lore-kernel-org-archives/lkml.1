Return-Path: <linux-kernel-owner+w=401wt.eu-S1754767AbYISQIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbYISQIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 12:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752482AbYISQIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 12:08:04 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:46013 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751294AbYISQIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 12:08:01 -0400
Date: Fri, 19 Sep 2008 12:08:01 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Justin Mattock <justinmattock@gmail.com>
cc: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Chris Snook <csnook@redhat.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Linux-usb <linux-usb@vger.kernel.org>
Subject: Re: [19.666764] Disabling IRQ #23
In-Reply-To: <dd18b0c30809181732t48b41806nadb60829a4fbdd67@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0809191206390.2429-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Sep 2008, Justin Mattock wrote:

> > You are concentrating on the symptom instead of the problem.  The
> > symptom is that "Disabling IRQ #23" message -- don't worry about it.
> >
> > The underlying problem is the "ehci_hcd 0000:00:1d.7: HC died;
> > cleaning up" message -- it should _never_ appear.  If you have a
> > reliable way of provoking it then something needs to be fixed.
> >
> > Alan Stern
> >
> >
> 
> The reliable way of provoking this message is

Which message?  The "Disabling IRQ #23" message or the "HC died; 
cleaning up" message?

> when uvcvideo is loading(not the module, but the tools involved with
> the communication of loading the firmware and module).
> i.g. when using the udev approach with isight-firware-tools
> I will receive this, but if I use the hal approach
> this message does not appear. Now with using the udev approach
> I did try this patch:(not knowing what it really was doing),
> http://www.gossamer-threads.com/lists/linux/kernel/966076
> And it seems this message has not appeared. From looking at the
> situation after running this patch irregardless if it was intended for this
> or not, I'm wondering if isight-firware-tools is the main issue with this
> rather than the kernel.

It doesn't matter what tools or other userspace programs you run; the 
"HC died; cleaning up" message should _never_ appear.

Alan Stern

