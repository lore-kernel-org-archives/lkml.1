Return-Path: <linux-kernel-owner+w=401wt.eu-S1755127AbXGBJJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127AbXGBJJB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 05:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbXGBJIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 05:08:53 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:46233
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbXGBJIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 05:08:52 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [2.6 patch] drivers/net/wireless/libertas/wext.c: remove dead code
Date: Mon, 2 Jul 2007 11:07:28 +0200
User-Agent: KMail/1.9.6
Cc: Adrian Bunk <bunk@stusta.de>, Dan Williams <dcbw@redhat.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20070701202040.GD10869@stusta.de> <1183366434.4089.96.camel@johannes.berg>
In-Reply-To: <1183366434.4089.96.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707021107.28390.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 July 2007 10:53:54 Johannes Berg wrote:
> On Sun, 2007-07-01 at 22:20 +0200, Adrian Bunk wrote:
> > This patch removes dead code introduced by
> > commit 90a42210f275e1f828eb6c08bf8252c2d6a774e0 and spotted
> > by the Coverity checker.
> 
> > --- linux-2.6.22-rc6-mm1/drivers/net/wireless/libertas/wext.c.old	2007-06-29 21:52:56.000000000 +0200
> > +++ linux-2.6.22-rc6-mm1/drivers/net/wireless/libertas/wext.c	2007-06-29 21:53:43.000000000 +0200
> > @@ -1823,85 +1823,82 @@ static int wlan_set_encodeext(struct net
> 
> out of curiosity, why so much context?

Because you see why it's dead code in the context and don't have
to lookup the code tree. ;)

-- 
Greetings Michael.
