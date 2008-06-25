Return-Path: <linux-kernel-owner+w=401wt.eu-S1758010AbYFYOZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010AbYFYOZF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 10:25:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755182AbYFYOYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 10:24:54 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56830 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752726AbYFYOYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 10:24:54 -0400
Date: Wed, 25 Jun 2008 10:24:53 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>
cc: David Vrabel <david.vrabel@csr.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       AntonioLin <antonio.lin@alcormicro.com>, <linux-usb@vger.kernel.org>
Subject: RE: Scatter-gather list constraints
In-Reply-To: <C72DEB015BA7724783363DE1AF6B0F980510BAC2@orsmsx417.amr.corp.intel.com>
Message-ID: <Pine.LNX.4.44L0.0806251023100.2578-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2008, Perez-Gonzalez, Inaky wrote:

> >From: David Vrabel [mailto:david.vrabel@csr.com]
> >
> >> That would be ideal.  However there is no way to pass an S-G list
> along
> >> with an URB; there's no field for it in the data structure.  And none
> >> of the existing host controller drivers support such a thing.
> >>
> >> I suppose we could add a field to struct urb and add a flag
> indicating
> >> whether the controller driver supports S-G lists.
> >
> >This is what I was thinking.
> 
> That would simplify a *LOT* of WUSB wire-adapter code which now is a
> horrible kludge.

In what way would it simplify the code?

Note that usbcore already contains a scatter-gather library.  
(Unfortunately the library is limited in usefulness because it needs to
run in process context.)

Alan Stern

