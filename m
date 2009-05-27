Return-Path: <linux-kernel-owner+w=401wt.eu-S1763101AbZE0Ms1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763101AbZE0Ms1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 08:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762819AbZE0MsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 08:48:12 -0400
Received: from gate1.ipvision.dk ([94.127.49.2]:53931 "EHLO gate1.ipvision.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762856AbZE0MsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 08:48:11 -0400
X-Greylist: delayed 1259 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 May 2009 08:48:11 EDT
To: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Cc: romieu@fr.zoreil.com (Francois Romieu), dave@thedillows.org (David Dillow),
       linux-kernel@vger.kernel.org, edward_hsu@realtek.com.tw (Edward Hsu)
Subject: Re: Realtek 8168D: no active link (2.6.29.2)
References: <20090519213213.GA6377@electric-eye.fr.zoreil.com>
	<200905251014.n4PAEi0k027544@mercury.physics.adelaide.edu.au>
From: Benny Amorsen <benny+usenet@amorsen.dk>
Date: Wed, 27 May 2009 14:27:04 +0200
In-Reply-To: <200905251014.n4PAEi0k027544@mercury.physics.adelaide.edu.au> (Jonathan Woithe's message of "Mon\, 25 May 2009 19\:44\:44 +0930 \(CST\)")
Message-ID: <m3octeu3xj.fsf@ursa.amorsen.dk>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Spam-Score: -5.2 (-----)
X-Spam-Report: ALL_TRUSTED=-3.3, AWL=1.166, BAYES_00=-3.099
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Woithe <jwoithe@physics.adelaide.edu.au> writes:

>   ethtool -s eth0 autoneg off speed 10
>     - 10 Mbps speed set
>
>   ethtool -s eth0 autoneg off speed 100
>     - 100 Mbps speed achieved
>
>   ethtool -s eth0 autoneg on speed 1000
>     - 1000 Mbps speed attained
>
> The duplex setting might not be having an effect though since my switch's
> FDx (full duplex) LED was extinguished for both the 10 and 100 Mbps cases
> above.  Explicitly setting the duplex flag using
>
>   ethtool -s eth0 autoneg off speed 100 duplex full
>
> didn't make any difference - the FDx LED remained off.

You turned auto negotiation off, and you are surprised that the switch
doesn't autonegotiate full duplex?


/Benny

