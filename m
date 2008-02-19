Return-Path: <linux-kernel-owner+w=401wt.eu-S1759385AbYBSRsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759385AbYBSRsw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 12:48:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754267AbYBSRsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 12:48:43 -0500
Received: from styx.suse.cz ([82.119.242.94]:57094 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754351AbYBSRsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 12:48:42 -0500
Date: Tue, 19 Feb 2008 18:48:41 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Tomas Carnecky <tom@dbservice.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: hid device not claimed but /dev/input/event exists
In-Reply-To: <47BB1515.1070608@dbservice.com>
Message-ID: <Pine.LNX.4.64.0802191846250.30955@jikos.suse.cz>
References: <47BB041F.4060003@dbservice.com> <Pine.LNX.4.64.0802191751040.7699@twin.jikos.cz>
 <47BB1515.1070608@dbservice.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2008, Tomas Carnecky wrote:

> The device apparently has four 'interfaces' - whatever that is, see [1]. 
> It seems like usbhid probes interface 2 (which is the LCD plus a few 
> buttons, probably the four just under the LCD, as described [1]). 
> Because usbhid doesn't know how to handle the buttons, it fails. But 
> then it probes interface 3 which is a 'proper' HID device with 
> well-defined buttons.

Yes, the dump clearly shows that.

Does anything appear in dmesg when you press those buttons? There should 
be messages resembling the one you already have there:

drivers/hid/hid-core.c: report (size 8) (unnumbered)
drivers/hid/hid-core.c: report 0 (size 8) =  00 00 28 00 00 00 00 00

and they should react to keys such as FastForward, Play, Mute, Volume Up, 
etc.

-- 
Jiri Kosina
SUSE Labs
