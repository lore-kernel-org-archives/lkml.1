Return-Path: <linux-kernel-owner+w=401wt.eu-S964949AbXBTIDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964949AbXBTIDM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 03:03:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964952AbXBTIDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 03:03:12 -0500
Received: from twin.jikos.cz ([213.151.79.26]:35260 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964949AbXBTIDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 03:03:11 -0500
Date: Tue, 20 Feb 2007 09:02:53 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Veronique & Vincent <vinctre@videotron.ca>
cc: marcel@holtmann.org, vincent.fortier1@ec.gc.ca,
       linux-kernel@vger.kernel.org
Subject: Re: Fwd: RE: Boot time Bluetooth BUG: warning: (value > m) at
 hid-core.c:793
In-Reply-To: <200702192111.47017.vinctre@videotron.ca>
Message-ID: <Pine.LNX.4.64.0702200854520.25686@twin.jikos.cz>
References: <200702192111.47017.vinctre@videotron.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Feb 2007, Veronique & Vincent wrote:

> Hi again Marcel and Jiri,
> I've set up the hid-core.c to DEBUG mode... and it literally got pretty verbose...

Vincent,

thanks for the output. Is this really the full output? The important part 
- report descriptor dump - seems to be missing in the output (it should 
read something like "hid-core.c: report descriptor (size XY, read YZ) = 
... some hexadecimal numbers". This should be output by the time the HID 
device is connected.

This output is generated in usb_hid_configure() function in hid-core.c

-- 
Jiri Kosina
