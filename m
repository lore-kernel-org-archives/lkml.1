Return-Path: <linux-kernel-owner+w=401wt.eu-S2993085AbXCIJfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993085AbXCIJfv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 04:35:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752670AbXCIJfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 04:35:51 -0500
Received: from main.gmane.org ([80.91.229.2]:60446 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663AbXCIJfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 04:35:50 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [PATCH] chaostables
Date: Fri, 09 Mar 2007 09:35:37 +0000
Message-ID: <45F12A69.1060406@ufomechanic.net>
References: <Pine.LNX.4.61.0703080723280.2448@yvahk01.tjqt.qr> <20070308131412.08d9973e@lxorguk.ukuu.org.uk> <Line.LNX.4.64.0703080955060.8029@d.namei> <Pine.LNX.4.61.0703081652310.2448@yvahk01.tjqt.qr> <45F044A0.50001@trash.net> <Pine.LNX.4.61.0703082112300.521@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: 82.153.158.114
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
In-Reply-To: <Pine.LNX.4.61.0703082112300.521@yvahk01.tjqt.qr>
Cc: netfilter-devel@lists.netfilter.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Jan Engelhardt wrote, On 08/03/07 20:26:
> xt_portscan needs to keep track of what packets the machine has already 
> seen. So on the first SYN, the connection is marked with "1". (Then we 
> send our SYN-ACK... and the connection turns ESTABLISHED.) The next 
> packet that is received will be an ACK or an RST. But it must come 
> _exactly after_ the SYN, so just using --tcp-flags ACK will not work. A 
> state which can be remembered is required. For that, an automaton is 
> used, whose state is saved in the connection mark.

There would me more point in having this as a new match if it didn't
trample on the connection mark, but used it's own slot or flag-bit.

Sam

