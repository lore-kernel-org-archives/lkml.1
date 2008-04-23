Return-Path: <linux-kernel-owner+w=401wt.eu-S1757090AbYDWVgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757090AbYDWVgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 17:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbYDWVg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 17:36:29 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:43913 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430AbYDWVg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 17:36:28 -0400
Date: Wed, 23 Apr 2008 23:36:25 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Chris Hallinan <challinan@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: iwl4965 regression since 2.6.24
Message-ID: <20080423213625.GE4783@ics.muni.cz>
References: <20080423124105.GA4783@ics.muni.cz> <c4aed99f0804230916h7eeff631ub4bba502844aebdd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c4aed99f0804230916h7eeff631ub4bba502844aebdd@mail.gmail.com>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 206.196.180.225
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Wed, 23 Apr 2008 23:36:25 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2008 at 12:16:34PM -0400, Chris Hallinan wrote:
> I tried associating manually using the AP address itself, to all the
> cells I could see, but could not get past the "Link Quality: 0" issue.
> 
> Windows XP on this same laptop connected immediately and worked. :(

I found out that iwconfig wlan0 ap auto (which according to the man page
should reassociate with the strongest AP) does nothing at all. 

It seems that once associated with AP, the mac or iwl4965 driver (do not know
which one) is unable to associate with a different AP.

-- 
Luká¹ Hejtmánek
