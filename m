Return-Path: <linux-kernel-owner+w=401wt.eu-S1754855AbZCUGgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbZCUGgx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 02:36:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753742AbZCUGgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 02:36:41 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:38184 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410AbZCUGgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 02:36:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:to:cc:subject:references:from:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=QMMmYnmkdaVgJ19aF4hbVWcsjEASC36YrrN/IYR37YS3+/vBXbR0N/tiDvyiYVa9mU
         +qDVkDxm8i6mZAKgM8iXfBYZHDu4pqvLok0v45+luM/nBxdfwKDnZp4u1m8xLrEo0oTL
         itJt8peuwDLc8hQB7jJekm6rEkNpT3ouLcTKU=
To: Christian Lamparter <chunkeey@web.de>
Cc: Michael Buesch <mb@bu3sch.de>, Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] p54: fix SoftLED compile dependencies
References: <20090319221024.5e2ad6e5.sfr@canb.auug.org.au>
	<49C293CC.6020009@oracle.com> <200903191955.00718.mb@bu3sch.de>
	<200903210057.47067.chunkeey@web.de>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sat, 21 Mar 2009 08:36:33 +0200
In-Reply-To: <200903210057.47067.chunkeey@web.de> (Christian Lamparter's message of "Sat\, 21 Mar 2009 00\:57\:46 +0100")
Message-ID: <87eiwre61a.fsf@litku.valot.fi>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Lamparter <chunkeey@web.de> writes:

> This patch fixes a compile problem when the MAC80211_LEDS
> triggers are enabled but not LED class itself. 
> (which is sort of pointless, but anyway...)

[...]

> @@ -17,31 +18,6 @@ config P54_USB
>  	select CRC32
>  	---help---
>  	  This driver is for USB isl38xx based wireless cards.
> -	  These are USB based adapters found in devices such as:
> -
> -	  3COM 3CRWE254G72
> -	  SMC 2862W-G
> -	  Accton 802.11g WN4501 USB
> -	  Siemens Gigaset USB
> -	  Netgear WG121
> -	  Netgear WG111
> -	  Medion 40900, Roper Europe
> -	  Shuttle PN15, Airvast WM168g, IOGear GWU513
> -	  Linksys WUSB54G
> -	  Linksys WUSB54G Portable
> -	  DLink DWL-G120 Spinnaker
> -	  DLink DWL-G122
> -	  Belkin F5D7050 ver 1000
> -	  Cohiba Proto board
> -	  SMC 2862W-G version 2
> -	  U.S. Robotics U5 802.11g Adapter
> -	  FUJITSU E-5400 USB D1700
> -	  Sagem XG703A
> -	  DLink DWL-G120 Cohiba
> -	  Spinnaker Proto board
> -	  Linksys WUSB54AG
> -	  Inventel UR054G
> -	  Spinnaker DUT

This change wasn't mentioned in the commit log. Did this get included
by accident?

-- 
Kalle Valo
