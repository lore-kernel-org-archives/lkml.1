Return-Path: <linux-kernel-owner+w=401wt.eu-S934513AbXKPWIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934513AbXKPWIq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 17:08:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757578AbXKPWIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 17:08:38 -0500
Received: from amber.ccs.neu.edu ([129.10.116.51]:45613 "EHLO
	amber.ccs.neu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757918AbXKPWIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 17:08:37 -0500
X-Greylist: delayed 2262 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Nov 2007 17:08:37 EST
Date: Fri, 16 Nov 2007 16:30:46 -0500 (EST)
From: Jim Faulkner <jfaulkne@ccs.neu.edu>
To: linux-kernel@vger.kernel.org
cc: Jim Faulkner <jfaulkne@ccs.neu.edu>
Subject: sb live (emu10k1) stops working between 2.6.23.1 and 2.6.23.7
Message-ID: <Pine.GSO.4.58.0711161613070.9346@denali.ccs.neu.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

I have an SB Live Value card which uses the emu10k1 driver.  I use digital
output to an external amplifier.  This has worked fine for many years, up
to and including kernel 2.6.23.1.  Under 2.6.23.7, I have been unable
to get any audio output.  I get the following errors when loading my
asound.state under 2.6.23.7 using `alsactl restore`:
alsactl: set_control:991: warning: name mismatch (IEC958 Playback
Mask/IEC958 Playback Default) for control #222
alsactl: set_control:993: warning: index mismatch (3/0) for control #222
alsactl: set_control:993: warning: index mismatch (0/1) for control #223
alsactl: set_control:993: warning: index mismatch (1/2) for control #224
alsactl: set_control:985: warning: iface mismatch (3/2) for control #225
alsactl: set_control:987: warning: device mismatch (2/0) for control #225
alsactl: set_control:989: warning: subdevice mismatch (0/0) for control
#225
alsactl: set_control:991: warning: name mismatch (IEC958 Playback
Default/SB Live Analog/Digital Output Jack) for control #225
alsactl: set_control:993: warning: index mismatch (2/0) for control #225
alsactl: set_control:995: failed to obtain info for control #225
(Operation not permitted)

I receive no errors when I load my asound.state under 2.6.23.1.

Under 2.6.23.7, I get the message "No digital data" on my external
amplifier, which normally I only see when the computer is powered down or
rebooting.  I do not get that message under 2.6.23.1, even when no audio
is being played.

I've tried copying down my alsamixer settings under 2.6.23.1, and
re-entering them under 2.6.23.7, however I have still been unable to get
any audio output.

Here is the relevant part of my `lspci -v`:
05:0d.0 Multimedia audio controller: Creative Labs SB Live! EMU10k1 (rev
08)
        Subsystem: Creative Labs CT4780 SBLive! Value
        Flags: bus master, medium devsel, latency 64, IRQ 23
        I/O ports at dce0 [size=32]
        Capabilities: [dc] Power Management version 2

Please let me know if you need any more information, and please CC my
e-mail address on any correspondence, since I am not subscribed to this
list.

thanks,
Jim Faulkner

