Return-Path: <linux-kernel-owner+w=401wt.eu-S1754943AbYHZUOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943AbYHZUOu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 16:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbYHZUO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 16:14:27 -0400
Received: from relay.2ka.mipt.ru ([194.85.80.65]:55950 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672AbYHZUOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 16:14:25 -0400
Date: Wed, 27 Aug 2008 00:14:07 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Denys Fedoryshchenko <denys@visp.net.lb>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: loaded router, excessive getnstimeofday in oprofile
Message-ID: <20080826201406.GA24827@2ka.mipt.ru>
References: <200808220457.40892.denys@visp.net.lb>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808220457.40892.denys@visp.net.lb>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2008 at 04:57:40AM +0300, Denys Fedoryshchenko (denys@visp.net.lb) wrote:
> I have loaded router (~650 Mbps In+Out), based on 2xAMD Opteron 248, Sun Fire 
> X4100. HPET timer available (TSC seems not available on this platform).
> Network interfaces is onboard, connected over PCI-X.
> 
> Right now i am using only one processor, cause using only one interface and 
> interrupts stick to it. Other is almost not used.
> At peak time i notice in mpstat, that this processor is almost "dead", and if 
> i run minor application consuming resources - ping over this router will be 
> terrible. For me it is clear - system overloaded. I did oprofile, and here is 
> result (at low load time, but at peak time it is very similar).

Do you have any packet sockets in this system? Like running dhcp daemon?

-- 
	Evgeniy Polyakov
