Return-Path: <linux-kernel-owner+w=401wt.eu-S933005AbXBVKij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933005AbXBVKij (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 05:38:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933011AbXBVKij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 05:38:39 -0500
Received: from relais.videotron.ca ([24.201.245.36]:14065 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933005AbXBVKii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 05:38:38 -0500
Date: Thu, 22 Feb 2007 05:38:39 -0500
From: Veronique & Vincent <vinctre@videotron.ca>
Subject: Re: Boot time Bluetooth BUG: warning: (value > m) at hid-core.c:793
In-reply-to: <20070221185012.e4deeb68.zaitcev@redhat.com>
To: Pete Zaitcev <zaitcev@redhat.com>, Jiri Kosina <jikos@jikos.cz>
Cc: marcel@holtmann.org, vincent.fortier1@ec.gc.ca,
       linux-kernel@vger.kernel.org
Message-id: <200702220538.39341.vinctre@videotron.ca>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200702192111.47017.vinctre@videotron.ca>
 <Pine.LNX.4.64.0702200854520.25686@twin.jikos.cz>
 <20070221185012.e4deeb68.zaitcev@redhat.com>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > > I've set up the hid-core.c to DEBUG mode... and it literally got pretty 
verbose...
> 
> > thanks for the output. Is this really the full output? The important part 
> > - report descriptor dump - seems to be missing in the output (it should 
> > read something like "hid-core.c: report descriptor (size XY, read YZ) = 
> > ... some hexadecimal numbers". This should be output by the time the HID 
> > device is connected.

The full dmesg with define DEBUG was included in the original message.  Unless 
something else was needed?

> Can I get something useful without a kernel recompile, with something
> like evtest? I have users on Fedora hitting this too. It very likely is
> a regression caused by the new unified HID.

I was actually getting that on a stock FC6 kernel.  The dmesg output comes 
from a recompiled vanilla 2.6.19.x with the exact same configuration BUT the 
modified define's in hid-core.c and a local version appended to the .config 
file.  So this BUG does not only affect FC6 users but also the vanilla 
kernel.

> https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=227598
> https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=228755

Good thing, I've added myself to the CC list of both.

> 
> -- Pete
> 

- vin
