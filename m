Return-Path: <linux-kernel-owner+w=401wt.eu-S1754856Ab0AMIew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab0AMIew (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 03:34:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707Ab0AMIev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 03:34:51 -0500
Received: from citadel.icyb.net.ua ([212.40.38.140]:3613 "EHLO
	citadel.icyb.net.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab0AMIeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 03:34:50 -0500
X-Greylist: delayed 805 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Jan 2010 03:34:49 EST
Message-ID: <4B4D8212.6080806@icyb.net.ua>
Date: Wed, 13 Jan 2010 10:19:30 +0200
From: Andriy Gapon <avg@icyb.net.ua>
User-Agent: Thunderbird 2.0.0.23 (X11/20091128)
MIME-Version: 1.0
To: Gabriel C <nix.or.die@googlemail.com>
CC: Justin Piszcz <jpiszcz@lucidpixels.com>, Gabriel C <crazy@frugalware.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Dan Williams <dan.j.williams@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] Status/support for Linux HECI from Intel? (for 
 temp/voltage monitoring)
References: <alpine.DEB.1.10.0812300700410.11356@p34.internal.lan>	 <4964DB3E.6080908@intel.com>	 <alpine.DEB.1.10.0901071142200.29147@p34.internal.lan>	 <1231356111.6648.2.camel@maxim-laptop> <49937CDF.10307@frugalware.org>	 <alpine.DEB.1.10.0902121236120.19381@p34.internal.lan> <1820d69d1001040551k26cfd925q4ada6b226740ac30@mail.gmail.com>
In-Reply-To: <1820d69d1001040551k26cfd925q4ada6b226740ac30@mail.gmail.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 04/01/2010 15:51 Gabriel C said the following:
> @Andriy there is a smallish bug in your original code .. you should
> use ..... , abs(value) ...., abs(value) ...);
> that will solve the negative CPU TEMP values you get with your version.

I wasn't sure about this, my impression was that negative temperatures were
offsets from some threshold.  E.g. Tcur - Tcrit.  In my case I saw negative
temperature only for CPU which fitted the hypothesis.

-- 
Andriy Gapon
