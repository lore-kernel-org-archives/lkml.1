Return-Path: <linux-kernel-owner+w=401wt.eu-S1751203AbXEXO1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751203AbXEXO1w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 10:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750760AbXEXO1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 10:27:45 -0400
Received: from mail.safenet.se ([84.243.19.88]:44061 "HELO mail.safenet.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750736AbXEXO1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 10:27:44 -0400
Message-ID: <4655A0DC.2070600@pakompetens.se>
Date: Thu, 24 May 2007 16:27:40 +0200
From: Nicklas Bondesson <nicklas.bondesson@pakompetens.se>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Mixing tagged and untagged vlans using via-velocity driver
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am trying to setup two vlans (one tagged and one untagged) using the 
native via-velocity driver in kernel 2.6.21.1 on a single nic (VIA 
VT6122 Gigabit).

I can set it up tagged or untagged without any problems, but not both at 
the same time. Is this even possible with this driver?

To enable vlan5 tagging on the nic I have tried the following:

alias eth1 via_velocity
options eth1 enable_tagging=1 VID_setting=5

At this point I can communicate with vlan5. When I try to bring up a 
virtual interface using vconfig it seems to inherit the vlan5 tagging, 
thus making it impossible to communicate with an untagged vlan.

I have also tried the other way around. If I skip "enable_tagging=1 
VID_setting=5", I can communicate with a non tagged vlan. If I bring up 
a new virtual interface (tagged vlan5) using vconfig it does not work.

Could it have something to do with the fact that this card supports vlan 
hw accelleration and upsets vconfig?

I'm stuck. If anyone could shed some light on this it would be greatly 
appreciated.

Nicklas
