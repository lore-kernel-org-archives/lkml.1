Return-Path: <linux-kernel-owner+w=401wt.eu-S1758967AbYCHBkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758967AbYCHBkT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 20:40:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbYCHBkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 20:40:06 -0500
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:41066 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751218AbYCHBkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 20:40:05 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=YRT3r/hMxAYFs/tSEpcKy3vy+u+qFuEZMb2wsNfZit0oP6LoaSOH/QB47eyi7y3/2eethfXR2MTLslh7x6Wz5Y+dYC3OQqb7RUDhlnPdExkKgSn0Ma61yXwi80vCTXiI9GoAZ8/ushiVmEN0oYPXGho7TTi1+xKZHsI24Z3M9k0=  ;
X-YMail-OSG: jYIhqZwVM1kDgpneAcecCrfBM2PTVjyoTC9W9NDFELDOzTcK1s9qar4eO9R0bUcGD1GtJpDIQQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [UPDATED v3][PATCH 5/7] regulator: sysfs ABI
Date: Fri, 7 Mar 2008 17:13:57 -0800
User-Agent: KMail/1.9.6
Cc: Liam Girdwood <lg@opensource.wolfsonmicro.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <1204827125.15360.151.camel@a10323.wolfsonmicro.main>
In-Reply-To: <1204827125.15360.151.camel@a10323.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200803071713.57795.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 March 2008, Liam Girdwood wrote:

> +What:		/sys/class/regulator/.../microvolts
> +	...
> +
> +What:		/sys/class/regulator/.../microamps
> +	...

Versus Documentation/hwmon/sysfs-interface which uses
millivolts and milliamperes respectively.

Why not adopt the same convention?  (This applies to
many attributes, not just these two.)


Also, I'm kind of curious what you've thought about
power budgeting.  Example, a power supply ("regulator")
may be able to supply a voltage within a given range,
but only up to a maximum of 200 mA worth.

The model visible through these sysfs attributes seems to
be an either/or thing ... either regulating voltage, or
current, but not addressing the corresponding constraints
on the other one.


> +               NOTE: this will return the string 'constraint not defined'

How about just "undefined" for all those min/max values?


> +What:		/sys/class/regulator/.../requested_microamps
> +	...

Ditto re "milli" vs "micro".  Also, "requested" seems a bit opaque.
As a sum, maybe "total_mi{lli,cro}amps" would be more explanatory.

- Dave

