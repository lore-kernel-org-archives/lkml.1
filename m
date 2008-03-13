Return-Path: <linux-kernel-owner+w=401wt.eu-S1757614AbYCMXTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614AbYCMXTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 19:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752636AbYCMXTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 19:19:10 -0400
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:30183 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751600AbYCMXTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 19:19:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=q/3rO0dwtDy9g4+O5nZ4eljgZ+/ZVZ6Bdhtg0/xb7qVlsBfwnK8t8mqQXyBeUSEun7E+xE+IZvYnSFwnVa3S7hdPvUNuYnMxjPV6FBvwcdFJRKaE+jyr+rTz3NlPoc9peAmmf34KlBjRAdtcdvPxezxuOBaNjUzzmaXOchDl8QM=  ;
X-YMail-OSG: a_VHo70VM1m9snhmM4ZTIlQ9QgLlEkjMne_HwzQv89NkVl8QWhaNZJI.ukvzt4mVgddc4qw05Q--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2.6.25-rc5 1/2] gpiolib:  dynamic gpio number allocation
Date: Thu, 13 Mar 2008 15:18:58 -0800
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, avorontsov@ru.mvista.com
References: <200803131549.54632.david-b@pacbell.net> <20080313160039.b69a5d24.akpm@linux-foundation.org>
In-Reply-To: <20080313160039.b69a5d24.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803131618.58516.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 March 2008, Andrew Morton wrote:

> hm.  I suppose that if someone want a huge number of GPIOs then we can
> convert this to a bitmap or an IDR tree easily enough.

Actually, I tried IDRs for a while and they broke platforms
which needed to initialize and use GPIOs early: before kmalloc
would work.  A real PITA that was -- and slow too.


> Shouldn't ARCH_NR_GPIOS be CONFIG_NR_GPIOS?

No more than NR_IRQS is settable via Kconfig.  And for
rather similar reasons.  :)

- Dave
