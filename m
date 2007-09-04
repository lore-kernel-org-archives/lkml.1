Return-Path: <linux-kernel-owner+w=401wt.eu-S1755546AbXIDP1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546AbXIDP1b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 11:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754568AbXIDP1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 11:27:24 -0400
Received: from ns1.suse.de ([195.135.220.2]:38298 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754461AbXIDP1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 11:27:23 -0400
From: Andi Kleen <ak@suse.de>
To: Alistair John Strachan <alistair@devzero.co.uk>
Subject: Re: 2.6.23-rc4-mm1
Date: Tue, 4 Sep 2007 16:26:27 +0100
User-Agent: KMail/1.9.1
Cc: Nicolas Mailhot <nicolas.mailhot@laposte.net>,
       linux-kernel@vger.kernel.org
References: <20070902045634.06ea0515@loke.fish.not> <loom.20070903T100420-157@post.gmane.org> <200709041620.47213.alistair@devzero.co.uk>
In-Reply-To: <200709041620.47213.alistair@devzero.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709041626.27945.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Seconded. It's been largely ignored which is annoying because the HPET
> works perfectly on this board. I assume the reason is still that nobody
> from NVIDIA verified hardward support for the hack.

It's IMHO a bad idea to add any overrides without access to data sheets
and errata sheets. The hardware might be broken and do bad
(subtle) bad things with HPET.  That's not a theoretical case.
There used to be at least one case where a chipset would occasionally
destroy the BIOS flash when HPET was force enabled.

That means for Intel it's fine to do (because errata sheets are public); but 
for Nvidia and VIA it's dangerous and should not be done.

-Andi
