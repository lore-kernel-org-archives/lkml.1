Return-Path: <linux-kernel-owner+w=401wt.eu-S1761283AbYDLIvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761283AbYDLIvP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 04:51:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757539AbYDLIu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 04:50:57 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:40902 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756240AbYDLIu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 04:50:56 -0400
Date: Sat, 12 Apr 2008 10:50:51 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Johannes Berg <johannes@sipsolutions.net>
cc: linux-kernel@vger.kernel.org, Josh Triplett <josh@freedesktop.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-wireless@vger.kernel.org, linux-sparse@vger.kernel.org
Subject: Re: [RFC 3/3] mac80211: annotate with __requires_rcu
In-Reply-To: <20080410134829.412424000@sipsolutions.net>
Message-ID: <Pine.LNX.4.64.0804121050160.28120@vixen.sonytel.be>
References: <20080410134810.629048000@sipsolutions.net>
 <20080410134829.412424000@sipsolutions.net>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-1964633417-1207990251=:28120"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-1964633417-1207990251=:28120
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 10 Apr 2008, Johannes Berg wrote:
> --- everything.orig/net/mac80211/key.h	2008-04-10 15:36:20.000000000 +0200
> +++ everything/net/mac80211/key.h	2008-04-10 15:36:45.000000000 +0200
> @@ -146,7 +146,7 @@ struct ieee80211_key *ieee80211_key_allo
>   */
>  void ieee80211_key_link(struct ieee80211_key *key,
>  			struct ieee80211_sub_if_data *sdata,
> -			struct sta_info *sta);
> +			struct sta_info *sta) __requires(RCU);
                                              ^^^^^^^^^^^^^^^
					      __requires_rcu? (for consistency)

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

Sony Network and Software Technology Center Europe
A division of Sony Service Centre (Europe) N.V.
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium
VAT BE 0413.825.160 · RPR Brussels
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619
---584349381-1964633417-1207990251=:28120--
