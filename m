Return-Path: <linux-kernel-owner+w=401wt.eu-S1758194AbZDEJxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194AbZDEJxx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 05:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756460AbZDEJxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 05:53:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:34480 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758073AbZDEJxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 05:53:37 -0400
Subject: Re: ath9k becon loss messages
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: Sujith <Sujith.Manoharan@atheros.com>,
       wireless <linux-wireless@vger.kernel.org>,
       David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200904051129.38904.mb@bu3sch.de>
References: <1238923439.4120.9.camel@localhost.localdomain>
	 <200904051129.38904.mb@bu3sch.de>
Content-Type: text/plain
Date: Sun, 05 Apr 2009 15:22:54 +0530
Message-Id: <1238925174.4120.12.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-04-05 at 11:29 +0200, Michael Buesch wrote:
> > [ 1678.823011] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > [ 1798.830589] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > [ 1918.828044] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > [ 2038.827224] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > [ 2116.517152] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > [ 2158.840243] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > [ 2278.827427] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> 
> 
> I think this message should only show if CONFIG_MAC80211_VERBOSE_DEBUG is set.
> It's kind of expected that we lose a beacon once in a while, so we shouldn't print
> verbose messages to the kernel log (even if they are KERN_DEBUG).
> 
> And besides that, I think one can easily remotely trigger this message and flood the logs.
> So it should probably _also_ be ratelimited.
> 

normally it prints after 120 seconds:

[ 1078.848434] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
[ 1198.822913] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
[ 1318.824931] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
[ 1438.814157] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
[ 1558.827336] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
[ 1678.823011] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
[ 1798.830589] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
[ 1918.828044] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
[ 2038.827224] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
[ 2116.517152] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
[ 2158.840243] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
[ 2278.827427] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
[ 2398.827010] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
[ 2518.817295] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
[ 2638.821208] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
[ 2758.838757] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
[ 2878.825043] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
[ 2998.828296] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
[ 3118.821456] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
[ 3238.813293] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
[ 3358.816763] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
[ 3478.820291] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
[ 3598.815145] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
[ 3718.814290] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
[ 3838.829043] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
[ 3958.817294] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request

--
JSR

