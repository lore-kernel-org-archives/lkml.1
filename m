Return-Path: <linux-kernel-owner+w=401wt.eu-S1756247AbZBTNM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247AbZBTNM0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 08:12:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbZBTNMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 08:12:14 -0500
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:37124 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbZBTNMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 08:12:13 -0500
Date: Fri, 20 Feb 2009 13:12:09 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: General question (scheduler) with SSDs?
Message-ID: <20090220131209.GA21446@silver.sucs.org>
References: <alpine.DEB.1.10.0902190837270.19552@p34.internal.lan> <20090220094356.GB26124@silver.sucs.org> <ac3eb2510902200316m387ecb45n86a2ea7c6196b01@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3eb2510902200316m387ecb45n86a2ea7c6196b01@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 20, 2009 at 12:16:42PM +0100, Kay Sievers wrote:
> 
> Udev can write to the attribute itself. This should be all you need:
>   SUSBSYTEM=="block", ATTRS{model}=="ASUS-PHISON *", ATTR{queue/rotational}="1"

I tried 
SUBSYSTEM=="block", ATTRS{model}=="ASUS-PHISON *", ATTR{queue/rotational}="0"
but udevtest /sys/block/sda/ doesn't list it as firing (udev 117-8)...

-- 
Sitsofe | http://sucs.org/~sits/
