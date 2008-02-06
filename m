Return-Path: <linux-kernel-owner+w=401wt.eu-S1758901AbYBFWda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758901AbYBFWda (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 17:33:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756934AbYBFWdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 17:33:21 -0500
Received: from kuber.nabble.com ([216.139.236.158]:42045 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756777AbYBFWdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 17:33:21 -0500
Message-ID: <15316561.post@talk.nabble.com>
Date: Wed, 6 Feb 2008 14:33:19 -0800 (PST)
From: ggriffin10 <ggriffin10-nab@yahoo.com>
To: linux-kernel@vger.kernel.org
Subject: Re: T61P sound issue
In-Reply-To: <20080204194038.d8851b8d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: ggriffin10-nab@yahoo.com
References: <31e679430801270549u49e1c549qf602b36b07aabc2b@mail.gmail.com> <20080204194038.d8851b8d.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> ooh, a fellow t61p owner.  How's suspend and resume working?
I spent days getting it to work. I'm not an expert and don't know if made
any poor decisions, I tested suspend to ram in a bunch of configurations and
finally got it to work consistently. I think I have to restart the network
after resume, but I'm okay with that. Some things that may be of interest:

2.6.18-53.1.4.e15.centos.plus with native nvidia drivers

in /etc/grub.conf:
kernel /vmlinuz-2.6.18-53.1.4.el5.centos.plus ro agp=off
root=/dev/VolGroup00/LogVol00 rhgb quiet

in /ext/X11/xorg.conf:
Section "Device"
    Identifier     "Videocard0"
    Driver         "nvidia"
EndSection

Section "Screen"
    Identifier     "Screen0"
    Device         "Videocard0"
    Monitor        "Monitor0"
    DefaultDepth    24
    Option         "NvAgp" "1"
    Option         "NoLogo" "true"
    Option         "ConnectedMonitor" "DFP"
    Option         "TripleBuffer" "True"
    Option         "FlatPanelProperties" "Scaling = Native"
    SubSection     "Display"
        Viewport    0 0
        Depth       24
        Modes      "800x600" "640x480"
    EndSubSection
EndSection


-- 
View this message in context: http://www.nabble.com/T61P-sound-issue-tp15119408p15316561.html
Sent from the linux-kernel mailing list archive at Nabble.com.

