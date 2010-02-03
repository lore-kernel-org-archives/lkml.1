Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279Ab0BCJZH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 04:25:07 -0500
Received: from mx51.mymxserver.com ([85.199.173.110]:35913 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756617Ab0BCJZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 04:25:01 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: Linux wireless GSoC 2010 project ideas
Date: Wed, 3 Feb 2010 10:23:24 +0100
User-Agent: KMail/1.9.7
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, david@lang.hm,
       "Luis R. Rodriguez" <mcgrof@gmail.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Witold Sowa <witold.sowa@gmail.com>,
       Till Kamppeter <till.kamppeter@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, lsb-discuss@lists.linux-foundation.org
References: <43e72e891001281338u5f05307ble5360c3dac6ab9a2@mail.gmail.com> <alpine.DEB.2.00.1002011216040.7748@asgard.lang.hm> <1265059913.26165.6.camel@maxim-laptop>
In-Reply-To: <1265059913.26165.6.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201002031023.25086.holgerschurig@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Also, like I said, this should be a analysis, and not
> wardriving/hacking tool.
> And with GUI.

Please define "analysis". What exactly should be analyzed?

Kismet can do:
* construct list of all beaconing APs and IBSS devices
* associate SSID to beacons because of assoc/auth req/resp
* construct a list of all stations around
* show used protection schema
* get simple packet statistics
* get simple signal level figures
* ...

But "analysis" can obviously be much more.

Some of the analysis should also be done on driver level, e.g. 
extend the nl80211-site-survey into mac80211 and add noise 
reporting to some drivers (I have something preliminary for 
ath5k). But also extend it to give channel occupation 
statistics.


And for a GUI, you could run kismet-server in the background and 
write a GUI (e.g. in Qt, so that it runs on X11/Mac/Win).

If the required analysis isn't easily put into kismet, you can of 
course write a new application if you please so :-)  I for 
example wrote a simple Qt application that has 25% of kismet's 
capability, but with a GUI. Unfortunately still Qt3.

-- 
http://www.holgerschurig.de
