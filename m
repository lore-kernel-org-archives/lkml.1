Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab0BAWM7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 17:12:59 -0500
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:34101 "EHLO
	emergent.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753556Ab0BAWM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 17:12:57 -0500
Date: Mon, 1 Feb 2010 17:12:52 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Witold Sowa <witold.sowa@gmail.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Till Kamppeter <till.kamppeter@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, lsb-discuss@lists.linux-foundation.org
Subject: Re: Linux wireless GSoC 2010 project ideas
Message-ID: <20100201221252.GA30758@emergent.ellipticsemi.com>
Mail-Followup-To: Maxim Levitsky <maximlevitsky@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Witold Sowa <witold.sowa@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Till Kamppeter <till.kamppeter@gmail.com>, Greg KH <greg@kroah.com>,
	linux-kernel@vger.kernel.org,
	lsb-discuss@lists.linux-foundation.org
References: <43e72e891001281338u5f05307ble5360c3dac6ab9a2@mail.gmail.com>
 <4B65F024.3080505@gmail.com>
 <1264972854.3597.17.camel@johannes.local>
 <43e72e891002011001l4e914094v33e73209a9da93e8@mail.gmail.com>
 <1265055284.26421.16.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265055284.26421.16.camel@maxim-laptop>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22:14 Mon 01 Feb     , Maxim Levitsky wrote:
> 2 - Allow a wireless card to associate to several APs at once (if they
> share the frequency). 
> Implement this at least for ath5/9k. Madwifi had that feature. Maybe
> ath9k has. If it has that feature, test it.

I haven't actually tried this particular case, but this is ostensibly
already supported by mac80211: iw allows you to create several wireless
interfaces that share a phy, which can then be configured into different
modes (I've used station + monitor successfully in the past).

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
