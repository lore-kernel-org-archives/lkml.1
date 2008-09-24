Return-Path: <linux-kernel-owner+w=401wt.eu-S1754478AbYIXUTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbYIXUTi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 16:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbYIXUT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 16:19:27 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:35023 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752160AbYIXUT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 16:19:27 -0400
Date: Wed, 24 Sep 2008 22:19:03 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: John Gumb <john.gumb@tandberg.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       "Kok, Auke" <auke-jan.h.kok@intel.com>
Subject: Re: D945GCLF  intel atom board & r8169 ethernet broken in
	linux-2.6.27-rc5??
Message-ID: <20080924201903.GA10546@electric-eye.fr.zoreil.com>
References: <9F6ACAE02B6DD040A1E259977622CFDB03F5BCCB@oslexcp1.eu.tandberg.int>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9F6ACAE02B6DD040A1E259977622CFDB03F5BCCB@oslexcp1.eu.tandberg.int>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Gumb <john.gumb@tandberg.com> :
[...]
> With linux-2.6.27-rc5, "ifconfig eth0" just hangs. lspci -vvx reports,
> after loading the driver,
> 
> > 01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8101E
> PCI Express Fast Ethernet controller (rev ff) (prog-if ff)
> >       !!! Unknown header type 7f
> 00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  
> 
> Before I load the driver lspci -vvx looks OK.

It is probably the driver's responsibility then.

> I do not have (much) time to look into this any further but hopefully
> this might help someone.

Can you try patches #0001 .. #0008 at
http://userweb.kernel.org/~romieu/r8169/2.6.27-rc6/20080913/ ?

-- 
Ueimor
