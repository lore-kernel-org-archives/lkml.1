Return-Path: <linux-kernel-owner+w=401wt.eu-S1945942AbXBBPsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945942AbXBBPsw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 10:48:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945946AbXBBPsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 10:48:52 -0500
Received: from elvis.franken.de ([193.175.24.41]:39909 "EHLO elvis.franken.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945942AbXBBPsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 10:48:51 -0500
X-Greylist: delayed 1821 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Feb 2007 10:48:51 EST
Date: Fri, 2 Feb 2007 16:18:29 +0100
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Joakim Tjernlund <joakim.tjernlund@transmode.se>,
       Netdev <netdev@vger.kernel.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]ip_auto_config bug in 2.6.20-rc6
Message-ID: <20070202151829.GA31844@alpha.franken.de>
References: <1170329187.15627.11.camel@gentoo-jocke.transmode.se> <1170421783.15627.23.camel@gentoo-jocke.transmode.se> <Pine.LNX.4.61.0702021424381.26531@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0702021424381.26531@yvahk01.tjqt.qr>
User-Agent: Mutt/1.5.9i
From: tsbogend@alpha.franken.de (Thomas Bogendoerfer)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 02, 2007 at 02:27:29PM +0100, Jan Engelhardt wrote:
> >> I think this is a bug since I am not using a NFS root FS.
> 
> I just wonder why IP_PNP has not been obsoleted and removed from the 
> tree yet, given that initramfs is the advertised way to do so such 
> things.

I hope this will not happen. Using BOOTP/NFS makes kernel hacking much
easier on not yet supported machines, which offer tftp in their firmware.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessary a
good idea.                                                [ RFC1925, 2.3 ]
