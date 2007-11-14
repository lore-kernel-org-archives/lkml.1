Return-Path: <linux-kernel-owner+w=401wt.eu-S1758850AbXKNLua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758850AbXKNLua (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 06:50:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756684AbXKNLuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 06:50:20 -0500
Received: from main.gmane.org ([80.91.229.2]:42042 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754677AbXKNLuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 06:50:18 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Benny Amorsen <benny+usenet@amorsen.dk>
Subject: Re: [PATCH 2/2] [e1000 VLAN] Disable vlan hw accel when promiscuous mode
Date: Wed, 14 Nov 2007 12:48:04 +0100
Message-ID: <m3sl39yrnv.fsf@ursa.amorsen.dk>
References: <47365200.0f10240a.0686.2173@mx.google.com> <47388988.1000506@intel.com> <47388B9F.7050308@trash.net> <20071112.143342.10809862.davem@davemloft.net> <4738D70C.4060404@nortel.com> <4738D9AB.8080408@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: hd5b9080a.c45-01-12.sta.perspektivbredband.net
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
Cancel-Lock: sha1:vFMOmgeFmH3onhs2gVRcWmGk114=
Cc: e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org
Cc: e1000-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "AK" == Kok, Auke <auke-jan.h.kok@intel.com> writes:

AK> actually the impact can be quite negative, imagine doing a tcpdump
AK> on a 10gig interface with vlan's enabled - all of a sudden you
AK> might accidentally flood the system with a 100-fold increase in
AK> traffic and force the stack to dump all those packets for you.

Why is the switch sending you all that traffic for VLAN's you don't
care about? I have a hard time imagining such a scenario. Sure, you
could have forgotten to limit the VLAN range sent to a particular
host, or even have decided that it's administratively easier to just
allow everything, but the switch still won't send unicast traffic out
that port unless the destination MAC matches. If broadcast or
non-solicited multicast takes up most of your bandwidth, you have
other problems.


/Benny


