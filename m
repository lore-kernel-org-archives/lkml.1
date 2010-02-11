Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab0BKMvT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 07:51:19 -0500
Received: from mail001.aei.ca ([206.123.6.130]:44055 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252Ab0BKMvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 07:51:18 -0500
From: Ed Tomlinson <edt@aei.ca>
To: Michael Poole <mdpoole@troilus.org>
Subject: Re: [PATCH 2/2] Add a device driver for the Apple Magic Mouse (2.6.32.8)
Date: Thu, 11 Feb 2010 07:51:14 -0500
User-Agent: KMail/1.12.4 (Linux/2.6.32.8-crc; KDE/4.3.5; x86_64; ; )
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       Marcel Holtmann <marcel@holtmann.org>, linux-bluetooth@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <alpine.LNX.2.00.1001291515560.356@pobox.suse.cz> <201002102205.58967.edt@aei.ca> <878wb0e9w2.fsf@troilus.org>
In-Reply-To: <878wb0e9w2.fsf@troilus.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002110751.14813.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 February 2010 22:20:13 Michael Poole wrote:
> Ed Tomlinson writes:
> 
> > Hi,
> >
> > When I apply this to head, I get:
> >
> > drivers/hid/hid-magicmouse.c: In function 'magicmouse_probe':                                                         
> > drivers/hid/hid-magicmouse.c:393: error: too many arguments to function 'hdev->hid_output_raw_report'                 
> > drivers/hid/hid-magicmouse.c:400: error: too many arguments to function 'hdev->hid_output_raw_report'                 
> >
> > I only need the second patch - the first seems to be in tree.
> >
> > Any ideas as to what I am missing?
> >
> > TIA
> > Ed
> 
> You're missing the patch that makes hid_output_raw_report() more generic.
> It is in the HID tree[1] as commit d4bfa033.
> 
> [1]- http://git.kernel.org/?p=linux/kernel/git/jikos/hid.git

Ok.  With this I have a patchset that applies to 2.6.32.8.  If anyone wants it
just email.  

Of course, Michael's cleanups came just after I booted with the new kernel.  I'll
apply it and update & post my changes that allow both x and y scrolling and almost 
work for a few multitouch gestures.

Ed
