Return-Path: <linux-kernel-owner+w=401wt.eu-S1751835AbXB0Vt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835AbXB0Vt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 16:49:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750916AbXB0Vt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 16:49:56 -0500
Received: from terminus.zytor.com ([192.83.249.54]:36891 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbXB0Vty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 16:49:54 -0500
Message-ID: <45E4A775.4020206@zytor.com>
Date: Tue, 27 Feb 2007 13:49:41 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: "Petri T. Koistinen" <petri.koistinen@iki.fi>
CC: netdev@vger.kernel.org, ShuChen <shuchen@realtek.com.tw>,
       linux-kernel@vger.kernel.org
Subject: Re: D-Link DGE-528T (r8159) autonegotation of 1000 Mbps link does
 not work
References: <Pine.LNX.4.64.0702242214120.1830@qfy-uxvtj8-sro4so00-137.qupc.varg.sv>
In-Reply-To: <Pine.LNX.4.64.0702242214120.1830@qfy-uxvtj8-sro4so00-137.qupc.varg.sv>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Petri T. Koistinen wrote:
> Hi!
> 
> I just brought two D-Link DGE-528T (uses r8159 driver) network adapters
> to have nice 1 Gbps home network between two computers.
> 
> I have gigabit crossover cable that is connected like this...
> 
> Pin  Connector #1  Connector #2
> 1    white/orange  white/green
> 2    orange        green
> 3    white/green   white/orange
> 4    blue          white/brown
> 5    white/blue    brown
> 6    green         orange
> 7    white/brown   blue
> 8    brown         white/blue
> (from: http://logout.sh/computers/net/gigabit/)

That's just plain screwy.  Gigabit doesn't use crossover cables *AT 
ALL*, although some of them *tolerate* the green and orange pairs being 
crossed for compatibility with older crossover cables.  However, the 
cable above is just plain weird.  There is absolutely no reason to cross 
the blue and brown pair.

If you know both ends are gigabit, always use a straight-through cable. 
  If you know at least one end is gigabit (or auto MDI/MDIX), you can 
almost always use a straight-through cable as well.  Use crossover 
cables for 10/100 equipment only.

	-hpa
