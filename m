Return-Path: <linux-kernel-owner+w=401wt.eu-S1759354AbXILErS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354AbXILErS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 00:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374AbXILErH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 00:47:07 -0400
Received: from smtp20.orange.fr ([80.12.242.26]:54431 "EHLO smtp20.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121AbXILErG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 00:47:06 -0400
X-ME-UUID: 20070912044705116.1C5371C00083@mwinf2002.orange.fr
Subject: Re: r8169: can't send magic packet for Wake-On-Lan
From: Xavier Bestel <xavier.bestel@free.fr>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: linux-kernel@vger.kernel.org, shuchen@realtek.com.tw
In-Reply-To: <20070911213017.GA661@electric-eye.fr.zoreil.com>
References: <1189545366.4403.9.camel@bip.parateam.prv>
	 <20070911213017.GA661@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset=ISO-8859-15
Date: Wed, 12 Sep 2007 06:32:06 +0200
Message-Id: <1189571526.6098.1.camel@bip.parateam.prv>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 11 septembre 2007 à 23:30 +0200, Francois Romieu a écrit :
> Xavier Bestel <xavier.bestel@free.fr> :
> [...]
> > with the r8169 I can't send a magic packet anymore. I'm using ethtool
> > for that, with the previous one (an rtl8139b) it was working very well.
> > ethtool -D apparently says it could send the packet ok.
> 
> I see no "-D" option in the sources from the git repository of ethtool.
> 
> Where did you find it ?

Err sorry, I mixed up everything ... I'm using *etherwake* to make the
WOL magic packet, and ethtool to check the interface options.

	Xav


