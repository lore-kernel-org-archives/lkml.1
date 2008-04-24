Return-Path: <linux-kernel-owner+w=401wt.eu-S1754161AbYDXJ0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbYDXJ0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 05:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbYDXJ0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 05:26:31 -0400
Received: from smtp2.dnainternet.fi ([87.94.96.112]:41863 "EHLO
	smtp2.dnainternet.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbYDXJ0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 05:26:30 -0400
Message-ID: <20080424122628.zioaht24o4ko4ww8@naisho.dyndns.info>
Date: Thu, 24 Apr 2008 12:26:28 +0300
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Roel Kluin <12o3l@tiscali.nl>, linux-wireless@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] wireless: rndis_wlan: modparam_workaround_interval is
	never below 0.
References: <480F97B5.9030009@tiscali.nl>
	(sfid-20080423_221109_783456_35B212E0)
	<1209027451.3357.49.camel@johannes.berg>
In-Reply-To: <1209027451.3357.49.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.1.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Johannes Berg <johannes@sipsolutions.net>:

>
> Eh, why not make the modparam unsigned and default to 500?
>
> johannes
>

Now that I stop and think about it, that would be better option. The  
modparam already has default value of 500.

Reason why workaround modparam is signed, is that value -1 did have  
some functionality in some early version. That then changed and  
priv->param_workaround_interval changed to unsigned and forgot about  
modparam.

  - Jussi Kivilinna


